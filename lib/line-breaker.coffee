{Point, Range} = require 'atom'

module.exports =
  activate: (state) ->
    atom.commands.add 'atom-workspace', 'line-breaker:break':
      => @break(true)
    atom.commands.add 'atom-workspace', 'line-breaker:break-no-indent':
      => @break(false)

  break: (preserveIndentation) ->
    @editor = atom.workspace.getActiveTextEditor()
    @maxLineLength = atom.config.get('editor.preferredLineLength') || 80

    # Get the current selection
    selection = @editor.getSelectedBufferRange()

    # Retrieve the first and last lines
    firstLine = @editor.lineTextForBufferRow(selection.start.row)
    lastLine = @editor.lineTextForBufferRow(selection.end.row)

    # Modify the selection to encapsulate whole lines
    selection = new Range([selection.start.row, 0],
                          [selection.end.row, lastLine.length])

    # Is every single line in the selection a comment?
    isComments = [selection.start.row..selection.end.row].every (row) =>
      return false unless 0 <= row <= @editor.getLastBufferRow()
      @editor.tokenizedBuffer.tokenizedLines[row]?.isComment()

    # Begin the mutation, make sure it's undoable in a single step
    @editor.transact =>
      # If the entire selection consists of comments, try to uncomment it to
      # determine the adjusted @maxLineLength.
      if isComments
        checkpoint = @editor.createCheckpoint()

        firstLineLength = =>
          @selectionParagraphs(selection)[0].split("\n")[0].length

        beforeUncomment = firstLineLength()
        @toggleComments(selection.start.row, selection.end.row)
        afterUncomment = firstLineLength()

        # If the uncommenting added text or didn't change the line, it  means
        # that Atom doesn't support the comment type (e.g. block  comments), and
        # the change should be reverted. Otherwise,  subtract the length of the
        # comment string from the max line  length.
        if afterUncomment >= beforeUncomment
          @editor.revertToCheckpoint(checkpoint)
          isComments = false
        else
          @maxLineLength -= (beforeUncomment - afterUncomment)

      # Retrain the indentation for each paragraph
      newText = (for para in @selectionParagraphs(selection)
        # Determine the indentation level that the paragraph should be on
        match = para.match(/^\s+/)
        indentation = if match then match[0] else ''

        if match
          # If we match on the indentation, replace all existing indentations
          # with a single space.
          para = para.replace(new RegExp("^#{indentation}", 'gm'), ' ')

        indentation = if preserveIndentation then indentation else ''
        @rebuildLines(indentation, para)).join("\n\n")

      # Replace the selection with the new text
      newRange = @editor.setTextInBufferRange(selection, newText)
      @toggleComments(newRange.start.row, newRange.end.row) if isComments

  # Get the lines in the selection and split them into an array
  selectionParagraphs: (selection) ->
    if selection.start.row == selection.end.row
      [@editor.getTextInBufferRange(selection)]
    else
      @editor.getTextInBufferRange(selection).split("\n\n")

  rebuildLines: (indentation, line) ->
    # Trim the line of any whitespace, and break it all down into words
    words = line.trim().replace(/\n/g, ' ').split(' ')
    sentence_generator = @generateSentence(words, indentation)

    (until (sentence = sentence_generator.next()).done
      sentence.value).join("\n")

  # Sentence generator from words and indentation.
  generateSentence: (words, indentation) ->
    currentLine = indentation

    for word in words
      if currentLine.length + word.length < @maxLineLength
        currentLine +=
          if currentLine.length == indentation.length
            word
          else
            ' ' + word
      else
        yield currentLine
        currentLine = indentation + word

    # If anything is left in the buffer, yield it.
    yield currentLine if currentLine.length > 0

  toggleComments: (start, end) ->
    @editor.languageMode.toggleLineCommentsForBufferRows(start, end)
