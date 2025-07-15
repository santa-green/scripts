function onOpen() {
  var ui = DocumentApp.getUi();
  ui.createMenu('Custom Menu')
      .addItem('CRITICAL', 'insertCriticalNoteTable')
      .addItem('WARNING', 'insertWarningNoteTable')
      .addItem('INFO', 'insertInformationNoteTable')
      .addItem('RECOMMEND', 'insertRecommendationNoteTable')
      .addItem('info', 'infoHighlightSelectionBlue')
      .addItem('set_italics_9', 'applyItalicsAndSize')
      .addItem('make_red', 'highlightSelectedTextRed')
      .addItem('highlight_blue', 'highlightSelectedTextBlue')
      .addToUi();
}


function insertRecommendationNoteTable() {
  var doc = DocumentApp.getActiveDocument();
  var body = doc.getBody();
  var cursor = doc.getCursor();

  if (!cursor) {
    DocumentApp.getUi().alert("Place the cursor where you want to insert the recommendation note.");
    return;
  }

  var ideaEmoji = "💡 ";
  var recommendationText = "INSERT_HERE";

  var element = cursor.getElement();

  // Find the nearest paragraph or body section ancestor
  var parent = element;
  while (parent && parent.getType() !== DocumentApp.ElementType.PARAGRAPH && parent.getType() !== DocumentApp.ElementType.BODY_SECTION) {
    parent = parent.getParent();
  }

  if (!parent) {
    parent = body.getChild(body.getNumChildren() - 1);
  }

  var index = body.getChildIndex(parent);

  // Insert a 1x1 table after the found element
  var table = body.insertTable(index + 1, [[""]]);
  var cell = table.getCell(0, 0);
  table.setColumnWidth(0, 600);  // sets the width of column 0 to 400 points (~5.5 inches), 600 - 8 inches.


  // Clear any existing content in the cell
  if (cell.getNumChildren() > 0) {
    for (var i = cell.getNumChildren() - 1; i >= 0; i--) {
      cell.removeChild(cell.getChild(i));
    }
  }

  // Insert idea emoji paragraph
  var emojiPara = cell.appendParagraph(ideaEmoji);
  emojiPara.setFontSize(14);
  emojiPara.setForegroundColor('#2E7D32'); // dark green
  emojiPara.setBold(true);
  emojiPara.setSpacingAfter(0);

  // Insert recommendation text paragraph
  var textPara = cell.appendParagraph(recommendationText);
  textPara.setFontFamily('Calibri');
  textPara.setFontSize(12);
  textPara.setSpacingBefore(0);

  // Set cell background color to light green
  cell.setBackgroundColor('#C8E6C9'); // light green

  // Optional: Set table properties
  table.setBorderWidth(3);
  table.setBorderColor('#006400');
}



function insertInformationNoteTable() {
  var doc = DocumentApp.getActiveDocument();
  var body = doc.getBody();
  var cursor = doc.getCursor();

  if (!cursor) {
    DocumentApp.getUi().alert("Place the cursor where you want to insert the note.");
    return;
  }

  var infoEmoji = "ℹ️ ";
  var infoText = "INSERT_HERE";

  var element = cursor.getElement();

  // Find the nearest paragraph or body section ancestor
  var parent = element;
  while (parent && parent.getType() !== DocumentApp.ElementType.PARAGRAPH && parent.getType() !== DocumentApp.ElementType.BODY_SECTION) {
    parent = parent.getParent();
  }

  if (!parent) {
    parent = body.getChild(body.getNumChildren() - 1);
  }

  var index = body.getChildIndex(parent);

  // Insert a 1x1 table after the found element
  var table = body.insertTable(index + 1, [[""]]);
  var cell = table.getCell(0, 0);
  table.setColumnWidth(0, 600);  // sets the width of column 0 to 400 points (~5.5 inches), 600 - 8 inches.
  


  // Clear any existing content
  if (cell.getNumChildren() > 0) {
    for (var i = cell.getNumChildren() - 1; i >= 0; i--) {
      cell.removeChild(cell.getChild(i));
    }
  }

  // Insert info emoji paragraph
  var emojiPara = cell.appendParagraph(infoEmoji);
  emojiPara.setFontSize(14);
  emojiPara.setForegroundColor('#0D47A1'); // dark blue
  emojiPara.setBold(true);
  emojiPara.setSpacingAfter(0);

  // Insert info text paragraph
  var textPara = cell.appendParagraph(infoText);
  textPara.setFontFamily('Calibri');
  textPara.setFontSize(12);
  textPara.setSpacingBefore(0);

  // Set cell background color to light blue
  cell.setBackgroundColor('#BBDEFB'); // light blue

  // Optional: Set table properties
  table.setBorderWidth(3);
  table.setBorderColor('#6495ED');

}



function insertCriticalNoteTable() {
  var doc = DocumentApp.getActiveDocument();
  var body = doc.getBody();
  var cursor = doc.getCursor();

  if (!cursor) {
    DocumentApp.getUi().alert("Place the cursor where you want to insert the note.");
    return;
  }

  var criticalEmoji = "🚨 ";
  var criticalText = "INSERT_HERE";

  var element = cursor.getElement();

  // Find the nearest paragraph or body section ancestor
  var parent = element;
  while (parent && parent.getType() !== DocumentApp.ElementType.PARAGRAPH && parent.getType() !== DocumentApp.ElementType.BODY_SECTION) {
    parent = parent.getParent();
  }

  if (!parent) {
    parent = body.getChild(body.getNumChildren() - 1);
  }

  var index = body.getChildIndex(parent);

  // Insert a 1x1 table after the found element
  var table = body.insertTable(index + 1, [[""]]);
  var cell = table.getCell(0, 0);
  table.setColumnWidth(0, 600);  // sets the width of column 0 to 400 points (~5.5 inches), 600 - 8 inches.


  // Clear any existing content
  if (cell.getNumChildren() > 0) {
    for (var i = cell.getNumChildren() - 1; i >= 0; i--) {
      cell.removeChild(cell.getChild(i));
    }
  }

  // Insert critical emoji paragraph
  var emojiPara = cell.appendParagraph(criticalEmoji);
  emojiPara.setFontSize(14);
  emojiPara.setForegroundColor('#B71C1C'); // dark red
  emojiPara.setBold(true);
  emojiPara.setSpacingAfter(0);

  // Insert critical text paragraph
  var textPara = cell.appendParagraph(criticalText);
  textPara.setFontFamily('Calibri');
  textPara.setFontSize(12);
  textPara.setSpacingBefore(0);

  // Set cell background color to light red
  cell.setBackgroundColor('#FFCDD2'); // light red/pinkish

  // Optional: Set table properties
  table.setBorderWidth(3);
  table.setBorderColor('#8B0000');
}



function insertWarningNoteTable() {
  var doc = DocumentApp.getActiveDocument();
  var body = doc.getBody();
  var cursor = doc.getCursor();

  if (!cursor) {
    DocumentApp.getUi().alert("Place the cursor where you want to insert the note.");
    return;
  }

  var warningText = "⚠️ ";
  var restText = "INSERT_HERE";

  var element = cursor.getElement();

  // Find the nearest paragraph or body section ancestor
  var parent = element;
  while (parent && parent.getType() !== DocumentApp.ElementType.PARAGRAPH && parent.getType() !== DocumentApp.ElementType.BODY_SECTION) {
    parent = parent.getParent();
  }

  if (!parent) {
    // If none found, insert at the end of the body
    parent = body.getChild(body.getNumChildren() - 1);
  }

  var index = body.getChildIndex(parent);

  // Insert a 1x1 table after the found element
  var table = body.insertTable(index + 1, [[""]]);
  var cell = table.getCell(0, 0);
  table.setColumnWidth(0, 600);  // sets the width of column 0 to 400 points (~5.5 inches), 600 - 8 inches.


  // Clear any existing content (should be empty but just in case)
  if (cell.getNumChildren() > 0) {
    for (var i = cell.getNumChildren() - 1; i >= 0; i--) {
      cell.removeChild(cell.getChild(i));
    }
  }

  // Insert warning emoji paragraph
  var warning = cell.appendParagraph(warningText);
  warning.setFontSize(14);
  warning.setForegroundColor('#E65100');
  warning.setBold(true);
  warning.setSpacingAfter(0);

  // Insert rest of text paragraph
  var textPara = cell.appendParagraph(restText);
  textPara.setFontFamily('Calibri');
  textPara.setFontSize(12);
  textPara.setSpacingBefore(0);

  // Set cell background color
  cell.setBackgroundColor('#FFE0B2');

  // Optional: Set table properties
  table.setBorderWidth(3);
  table.setBorderColor('#6495ED');

  // Optional: Set table properties
  table.setBorderWidth(3);
  table.setBorderColor('#B8860B');
}



function infoHighlightSelectionBlue() {
  var doc = DocumentApp.getActiveDocument();
  var selection = doc.getSelection();
  var emoji = "ℹ️ ";

  if (selection) {
    var elements = selection.getRangeElements();

    // Insert emoji at the start of the first element's selection
    var firstElem = elements[0];
    var element = firstElem.getElement();
    if (element.editAsText) {
      var text = element.editAsText();
      var startOffset = firstElem.getStartOffset();

      // Insert emoji only at the start of the selection
      text.insertText(startOffset, emoji);

      // Adjust all offsets because of the inserted emoji
      var emojiEnd = startOffset + emoji.length - 1;

      // Style the emoji itself
      text.setBold(startOffset, emojiEnd, true);
      text.setForegroundColor(startOffset, emojiEnd, "#ffffff");

      // Style the rest of the selection (selected text)
      var endOffset = firstElem.getEndOffsetInclusive() + emoji.length;
      text.setBold(emojiEnd + 1, endOffset, true);
      text.setForegroundColor(emojiEnd + 1, endOffset, "#1155CC");
      // text.setBackgroundColor(emojiEnd + 1, endOffset, "#008dde");
      text.setItalic(startOffset, endOffset, true); // Apply italics
      text.setFontSize(startOffset, endOffset, 9); // Set font size to 9
    }

    // Style the rest of the selected elements if the selection spans multiple elements
    for (var i = 1; i < elements.length; i++) {
      var el = elements[i].getElement();
      if (el.editAsText) {
        var t = el.editAsText();
        var s = elements[i].getStartOffset();
        var e = elements[i].getEndOffsetInclusive();
        t.setBold(s, e, true);
        t.setForegroundColor(s, e, "#ffffff");
        t.setBackgroundColor(s, e, "#008dde");
      }
    }
  } else {
    DocumentApp.getUi().alert("Please select the text you want to highlight and add the info emoji.");
  }
}



function applyItalicsAndSize() {
  var selection = DocumentApp.getActiveDocument().getSelection();
  
  if (selection) {
    var elements = selection.getRangeElements();
    for (var i = 0; i < elements.length; i++) {
      var element = elements[i].getElement();
      if (element.editAsText) {
        var text = element.editAsText();
        var startOffset = elements[i].getStartOffset();
        var endOffset = elements[i].getEndOffsetInclusive();
        text.setItalic(startOffset, endOffset, true); // Apply italics
        text.setFontSize(startOffset, endOffset, 9); // Set font size to 9
      }
    }
  }
}

function highlightSelectedTextRed() {
  var selection = DocumentApp.getActiveDocument().getSelection();
  
  if (selection) {
    var elements = selection.getRangeElements();
    for (var i = 0; i < elements.length; i++) {
      var element = elements[i].getElement();
      if (element.editAsText) {
        var text = element.editAsText();
        var startOffset = elements[i].getStartOffset();
        var endOffset = elements[i].getEndOffsetInclusive();
        text.setForegroundColor(startOffset, endOffset, "#9e003a"); // Red color
        text.setBold(startOffset, endOffset, true); // Make text bold
      }
    }
  }
}

function highlightSelectedTextBlue() {
  var selection = DocumentApp.getActiveDocument().getSelection();
  
  if (selection) {
    var elements = selection.getRangeElements();
    for (var i = 0; i < elements.length; i++) {
      var element = elements[i].getElement();
      if (element.editAsText) {
        var text = element.editAsText();
        var startOffset = elements[i].getStartOffset();
        var endOffset = elements[i].getEndOffsetInclusive();
        text.setForegroundColor(startOffset, endOffset, "#ffffff"); // White text
        text.setBackgroundColor(startOffset, endOffset, "#008dde"); // Blue highlight
        text.setBold(startOffset, endOffset, true); // Make text bold
      }
    }
  }
}