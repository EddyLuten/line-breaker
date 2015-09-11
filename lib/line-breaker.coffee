{Point, Range} = TextBuffer = require 'text-buffer'

module.exports =
  activate: (state) ->
    atom.commands.add 'atom-workspace', 'line-breaker:break': => @break()

  break: ->
    editor = atom.workspace.getActiveTextEditor()
    maxLineLength = atom.config.settings.editor.preferredLineLength || 80

    # get the current selection
    selection = editor.getSelectedBufferRange()

    # retrieve the first and last lines
    firstLine = editor.lineTextForBufferRow(selection.start.row)
    lastLine = editor.lineTextForBufferRow(selection.end.row)

    # modify the selection to encapsulate whole lines
    selection = new Range([selection.start.row, 0],
                          [selection.end.row, lastLine.length])

    # get the indentation level that the text should be on
    match = firstLine.match /^\s+/
    indentation = if null == match then '' else match[0]

    # get the lines in the selection and split them into an array
    if selection.start.row == selection.end.row
      lines = [editor.getTextInBufferRange(selection)]
    else
      lines = editor.getTextInBufferRange(selection).split("\n")

    # trim the line of any whitespace, and break it all down into words
    words = lines.map( (line) -> line.trim() ).join(' ').split(' ')

    # restructure the lines
    newLines = []
    currentLine = indentation
    for word in words
      if currentLine.length + word.length < maxLineLength
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

    # replace the selection with the new text
    editor.setTextInBufferRange(selection, newLines.join("\n"))
