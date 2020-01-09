-- |
-- Module      : Network.Socket.ByteString
-- Copyright   : (c) Johan Tibell 2007-2010
-- License     : BSD-style
--
-- Maintainer  : johan.tibell@gmail.com
-- Stability   : stable
-- Portability : portable
--
-- This module provides access to the BSD /socket/ interface.  This
-- module is generally more efficient than the 'String' based network
-- functions in 'Network.Socket'.  For detailed documentation, consult
-- your favorite POSIX socket reference. All functions communicate
-- failures by converting the error number to 'System.IO.IOError'.
--
-- This module is made to be imported with 'Network.Socket' like so:
--
-- > import Network.Socket
-- > import Network.Socket.ByteString
--
module Network.Socket.ByteString
    (
    -- * Send data to a socket
      send
    , sendAll
    , sendTo
    , sendAllTo

    -- ** Vectored I/O
    -- $vectored
    , sendMany
    , sendManyTo

    -- * Receive data from a socket
    , recv
    , recvFrom

    -- * Advanced send and recv
    , sendMsg
    , recvMsg
    , MsgFlag(..)
    , Cmsg(..)
    -- ** Ancillary data
    , Ancillary(..)
    , AncillaryID
    , ancillaryIPv4TTL
    , ancillaryIPv6HopLimit
    , ancillaryIPv4TOS
    , ancillaryIPv6TClass
    , ancillaryIPv4PktInfo
    , ancillaryIPv6PktInfo
    , lookupAncillary
    -- ** Types
    , IPv4TTL(..)
    , IPv6HopLimit(..)
    , IPv4TOS(..)
    , IPv6TClass(..)
    , IPv4PktInfo(..)
    , IPv6PktInfo(..)
    ) where

import Data.ByteString (ByteString)

import Network.Socket.ByteString.IO hiding (sendTo, sendAllTo, recvFrom)
import qualified Network.Socket.ByteString.IO as G
import Network.Socket.Types
import Network.Socket.ByteString.Ancillary

-- ----------------------------------------------------------------------------
-- ** Vectored I/O

-- $vectored
--
-- Vectored I\/O, also known as scatter\/gather I\/O, allows multiple
-- data segments to be sent using a single system call, without first
-- concatenating the segments.  For example, given a list of
-- @ByteString@s, @xs@,
--
-- > sendMany sock xs
--
-- is equivalent to
--
-- > sendAll sock (concat xs)
--
-- but potentially more efficient.
--
-- Vectored I\/O are often useful when implementing network protocols
-- that, for example, group data into segments consisting of one or
-- more fixed-length headers followed by a variable-length body.

-- | Send data to the socket.  The recipient can be specified
-- explicitly, so the socket need not be in a connected state.
-- Returns the number of bytes sent. Applications are responsible for
-- ensuring that all data has been sent.
sendTo :: Socket -> ByteString -> SockAddr -> IO Int
sendTo = G.sendTo

-- | Send data to the socket. The recipient can be specified
-- explicitly, so the socket need not be in a connected state.  Unlike
-- 'sendTo', this function continues to send data until either all
-- data has been sent or an error occurs.  On error, an exception is
-- raised, and there is no way to determine how much data, if any, was
-- successfully sent.
sendAllTo :: Socket -> ByteString -> SockAddr -> IO ()
sendAllTo = G.sendAllTo

-- | Receive data from the socket.  The socket need not be in a
-- connected state.  Returns @(bytes, address)@ where @bytes@ is a
-- 'ByteString' representing the data received and @address@ is a
-- 'SockAddr' representing the address of the sending socket.
recvFrom :: Socket -> Int -> IO (ByteString, SockAddr)
recvFrom = G.recvFrom

