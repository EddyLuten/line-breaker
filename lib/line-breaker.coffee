{Point, Range} = TextBuffer = require 'text-buffer'

module.exports =
  activate: (state) ->
    atom.commands.add 'atom-workspace', 'line-breaker:break': => @break()

  break: ->
    @editor = atom.workspace.getActiveTextEditor()
    @maxLineLength = atom.config.get('editor.preferredLineLength') || 80

    # get the current selection
    selection = @editor.getSelectedBufferRange()

    # retrieve the first and last lines
    firstLine = @editor.lineTextForBufferRow(selection.start.row)
    lastLine = @editor.lineTextForBufferRow(selection.end.row)

    # modify the selection to encapsulate whole lines
    selection = new Range([selection.start.row, 0],
                          [selection.end.row, lastLine.length])

    # Is every single line in the selection a comment?
    isComments = [selection.start.row..selection.end.row].every (row) =>
      @editor.languageMode.isLineCommentedAtBufferRow(row)

    # Begin the mutation, make sure it's undoable in a single step
    @editor.transact =>
      # Get the indentation level that the text should be on
      match = firstLine.match /^\s+/
      indentation = if null == match then '' else match[0]

      # If the entire selection consists of comments, try to uncomment it.
      if isComments
        checkpoint = @editor.createCheckpoint()

        beforeUncomment = @getCurrentLines(selection)[0].length
        @togleComments(selection.start.row, selection.end.row)
        afterUncomment = @getCurrentLines(selection)[0].length

        # If the uncommenting added text or didn't change the line, it means
        # that Atom doesn't support the comment type (e.g. block comments), and
        # the change should be reverted. Otherwise, subtract the length of the
        # comment string from the max line length.
        if afterUncomment >= beforeUncomment
          @editor.revertToCheckpoint(checkpoint)
          isComments = false
        else
          @maxLineLength -= (beforeUncomment - afterUncomment)

      oldLines = @getCurrentLines(selection)
      newLines = @rebuildLines(indentation, oldLines)

      # Replace the selection with the new text
      newRange = @editor.setTextInBufferRange(selection, newLines)
      @togleComments(newRange.start.row, newRange.end.row) if isComments

  # Get the lines in the selection and split them into an array
  getCurrentLines: (selection) ->
    if selection.start.row == selection.end.row
      [@editor.getTextInBufferRange(selection)]
    else
      @editor.getTextInBufferRange(selection).split("\n")

  rebuildLines: (indentation, lines) ->
    # Trim the line of any whitespace, and break it all down into words
    words = lines.map( (line) -> line.trim() ).join(' ').split(' ')

    newLines = []
    currentLine = indentation
    for word in words
      if currentLine.length + word.length < @maxLineLength
        currentLine +=
          if currentLine.length == indentation.length
            word
          else
            ' ' + word
      else
        newLines.push(currentLine)
        currentLine = indentation + word

    # if anything is left in the buffer, push it onto the new array
    newLines.push(currentLine) if currentLine.length > 0
    newLines.join("\n")

  togleComments: (start, end) ->
    @editor.languageMode.toggleLineCommentsForBufferRows(start, end)
