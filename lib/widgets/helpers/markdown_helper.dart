import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class CustomMarkdownBody extends MarkdownWidget {
  const CustomMarkdownBody({
    Key? key,
    required String data,
    bool selectable = false,
    MarkdownStyleSheet? styleSheet,
    MarkdownStyleSheetBaseTheme? styleSheetTheme,
    SyntaxHighlighter? syntaxHighlighter,
    MarkdownTapLinkCallback? onTapLink,
    VoidCallback? onTapText,
    String? imageDirectory,
    List<md.BlockSyntax>? blockSyntaxes,
    List<md.InlineSyntax>? inlineSyntaxes,
    md.ExtensionSet? extensionSet,
    MarkdownImageBuilder? imageBuilder,
    MarkdownCheckboxBuilder? checkboxBuilder,
    Map<String, MarkdownElementBuilder> builders = const {},
    MarkdownListItemCrossAxisAlignment listItemCrossAxisAlignment =
        MarkdownListItemCrossAxisAlignment.baseline,
    this.shrinkWrap = true,
    this.fitContent = true,
    this.maxLines,
    this.overflow,
  }) : super(
          key: key,
          data: data,
          selectable: selectable,
          styleSheet: styleSheet,
          styleSheetTheme: styleSheetTheme,
          syntaxHighlighter: syntaxHighlighter,
          onTapLink: onTapLink,
          onTapText: onTapText,
          imageDirectory: imageDirectory,
          blockSyntaxes: blockSyntaxes,
          inlineSyntaxes: inlineSyntaxes,
          extensionSet: extensionSet,
          imageBuilder: imageBuilder,
          checkboxBuilder: checkboxBuilder,
          builders: builders,
          listItemCrossAxisAlignment: listItemCrossAxisAlignment,
        );

  final TextOverflow? overflow;
  final int? maxLines;

  /// See [ScrollView.shrinkWrap]
  final bool shrinkWrap;

  /// Whether to allow the widget to fit the child content.
  final bool fitContent;

  void searchRichText(List<Widget> list) {
    for (final Widget item in list) {
      if (item is RichText) {
        final RichText newRichText = RichText(
          text: item.text,
          textScaleFactor: item.textScaleFactor,
          textAlign: item.textAlign,
          maxLines: maxLines,
          overflow: overflow ?? TextOverflow.visible,
        );

        list.insert(0, newRichText);
        list.remove(item);
        return;
      }
      if (item is Column) {
        searchRichText(item.children);
      } else if (item is Wrap) {
        searchRichText(item.children);
      }
    }
  }

  @override
  Widget build(BuildContext context, List<Widget>? children) {
    searchRichText(children!);
    if (children.length == 1) return children.single;
    return Column(
      mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
      crossAxisAlignment:
          fitContent ? CrossAxisAlignment.start : CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
