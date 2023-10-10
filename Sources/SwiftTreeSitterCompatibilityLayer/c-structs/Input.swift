//
//  File.swift
//  
//
//  Created by Taylor Lineman on 10/10/23.
//

import Foundation

/*
 * The [`TSInput`] parameter lets you specify how to read the text. It has the
 * following three fields:
 * 1. [`read`]: A function to retrieve a chunk of text at a given byte offset
 *    and (row, column) position. The function should return a pointer to the
 *    text and write its length to the [`bytes_read`] pointer. The parser does
 *    not take ownership of this buffer; it just borrows it until it has
 *    finished reading it. The function should write a zero value to the
 *    [`bytes_read`] pointer to indicate the end of the document.
 * 2. [`payload`]: An arbitrary pointer that will be passed to each invocation
 *    of the [`read`] function.
 * 3. [`encoding`]: An indication of how the text is encoded. Either
 *    `TSInputEncodingUTF8` or `TSInputEncodingUTF16`.
 *
 * This function returns a syntax tree on success, and `NULL` on failure. There
 * are three possible reasons for failure:
 * 1. The parser does not have a language assigned. Check for this using the
      [`ts_parser_language`] function.
 * 2. Parsing was cancelled due to a timeout that was set by an earlier call to
 *    the [`ts_parser_set_timeout_micros`] function. You can resume parsing from
 *    where the parser left out by calling [`ts_parser_parse`] again with the
 *    same arguments. Or you can start parsing from scratch by first calling
 *    [`ts_parser_reset`].
 * 3. Parsing was cancelled using a cancellation flag that was set by an
 *    earlier call to [`ts_parser_set_cancellation_flag`]. You can resume parsing
 *    from where the parser left out by calling [`ts_parser_parse`] again with
 *    the same arguments.
 *
 * [`read`]: TSInput::read
 * [`payload`]: TSInput::payload
 * [`encoding`]: TSInput::encoding
 * [`bytes_read`]: TSInput::read
 */
//final class Input {
//    let encoding: InputEncoding
//    
//    func read() {
//        
//    }
//}
