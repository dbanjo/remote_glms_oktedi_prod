CREATE OR REPLACE PACKAGE STX1.wpg_docload
AS

--
-- Public types and global variables
--
TYPE parts_table IS TABLE OF VARCHAR2(256) INDEX BY binary_integer;

-- The NAME column in your document table must be the same as the
-- value of name_col_len.
name_col_len CONSTANT pls_integer := 64;

-- The MIME_TYPE column in your document table must be the same as
-- the value of mimet_col_len.
mimet_col_len CONSTANT pls_integer := 48;

-- The name length of your document table must be less than
-- max_doctable_name_len.
max_doctable_name_len CONSTANT pls_integer := 256;

--
-- Public file upload/download procedures and functions
--

--
-- PROCEDURE:
--   download_file
-- DESCRIPTION:
--   This should be called from within a document download procedure
--   to signal the PL/SQL Gateway that p_filename is to be downloaded
--   from the document table to the client's browser.
--   Normally, a document will be downloaded to the browser unless the
--   browser sends an 'If-Modified-Since' header to the gateway indicating
--   that it has the requested document in its cache.  In that case,
--   the gateway will determine if the browser's cached copy is up to date,
--   and if it is, it will send a 304 message to the browser indicating
--   that the browser should display the cached copy.  However, because
--   a document URL and a document do not necessarily have a one-to-one
--   relationship in the PL/SQL Web Gateway, in some cases it may be
--   undesirable to have the cached copy of a document displayed.  In those
--   cases, the p_bcaching parameter should be set to FALSE to indicate to
--   the gateway to ignore the 'If-Modified-Since' header, and download the
--   document.
-- PARAMS:
--   p_filename   IN: file to download from the document table.
--   p_bcaching   IN: browser caching enabled?
--
PROCEDURE download_file(p_filename IN VARCHAR2,
			p_bcaching IN BOOLEAN DEFAULT true);

--
-- PROCEDURE:
--   download_file
-- DESCRIPTION:
--   This can be called from within any procedure to signal the
--   PL/SQL Gateway that p_blob is to be downloaded to the client's browser.
-- PARAMS:
--   p_blob   IN: blob to download
--
PROCEDURE download_file(p_blob IN OUT NOCOPY blob);

--
-- PROCEDURE:
--   download_file
-- DESCRIPTION:
--   This can be called from within any procedure to signal the
--   PL/SQL Gateway that p_bfile is to be downloaded to the client's browser.
-- PARAMS:
--   p_bfile   IN: bfile to download
-- NOTE:
--   p_bfile is declared here as an IN/OUT because the locator is
--   initially opened to check for file accessibility and existance.
--   The open can only be done if the locator is writable and readable.
PROCEDURE download_file(p_bfile IN OUT bfile);

--
-- Private file upload/download procedures and functions
--
-- **WARNING**
-- The following procedures are used internally by the
-- PL/SQL Gateway.  Do not call them from your PL/SQL code.
--

--
-- PROCEDURE:
--   get_download_file
-- DESCRIPTION:
--   Get the name and mime_type of the file to be downloaded
-- PARAMS:
--   p_doc_info      OUT: encoded document information
--
PROCEDURE get_download_file(p_doc_info OUT VARCHAR2);

--
-- PROCEDURE:
--   get_download_blob
-- DESCRIPTION:
--   Get the blob to be downloaded
-- PARAMS:
--   p_blob  OUT: blob to be downloaded
--
PROCEDURE get_download_blob(p_blob OUT NOCOPY blob);

--
-- PROCEDURE:
--   get_download_bfile
-- DESCRIPTION:
--   Get the bfile to be downloaded
-- PARAMS:
--   p_bfile  OUT: bfile to be downloaded
--
PROCEDURE get_download_bfile(p_bfile OUT bfile);

--
-- FUNCTION:
--   is_file_download
-- DESCRIPTION:
--   Is there a file to download?
-- PARAMS:
--   none
-- RETURN:
--   TRUE if there is a pending file download, FALSE otherwise.
--
FUNCTION is_file_download
  RETURN  BOOLEAN;

--
-- PROCEDURE:
--   get_content_length
-- DESCRIPTION:
--   Return the length of a lob to be downloaded.  This is only called
--   when the user hasn't already specified a predetermined content-length.
-- PARAMS:
--   none.
-- RETURN:
--   lob length
--
FUNCTION get_content_length
  RETURN pls_integer;

END wpg_docload;
/
