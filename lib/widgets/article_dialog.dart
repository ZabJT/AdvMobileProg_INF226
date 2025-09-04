import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/article_model.dart';
import '../services/article_service.dart';

class ArticleDialog extends StatefulWidget {
  final Article? article; // null for create, Article for edit
  final Function(Article) onArticleSaved;

  const ArticleDialog({super.key, this.article, required this.onArticleSaved});

  @override
  State<ArticleDialog> createState() => _ArticleDialogState();
}

class _ArticleDialogState extends State<ArticleDialog> {
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController contentController;
  late GlobalKey<FormState> formKey;
  late bool isActive;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.article?.title ?? '');
    authorController = TextEditingController(text: widget.article?.name ?? '');
    contentController = TextEditingController(
      text: widget.article?.content.join('\n') ?? '',
    );
    formKey = GlobalKey<FormState>();
    isActive = widget.article?.isActive ?? true;
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    contentController.dispose();
    super.dispose();
  }

  List<String> _toList(String raw) {
    // Split by newlines or commas, trim, drop empties.
    return raw
        .split(RegExp(r'[\n,]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  Future<void> save() async {
    if (isSaving) return;
    if (!formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    try {
      final payload = {
        'title': titleController.text.trim(),
        'name': authorController.text.trim(),
        'content': _toList(contentController.text),
        'isActive': isActive,
      };

      Map res;
      if (widget.article != null) {
        // Update existing article
        res = await ArticleService().updateArticle(
          widget.article!.aid,
          payload,
        );
      } else {
        // Create new article
        res = await ArticleService().createArticle(payload);
      }

      // Adjust depending on your API's response shape
      final created = (res['article'] ?? res);
      final newArticle = Article.fromJson(created);

      widget.onArticleSaved(newArticle);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.article != null ? 'Article updated.' : 'Article added.',
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to ${widget.article != null ? 'update' : 'add'}: $e',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.article != null ? 'Edit Article' : 'Add Article'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: authorController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Author / Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: contentController,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Content (one item per line or comma-separated)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (v) {
                  final items = _toList(v ?? '');
                  return items.isEmpty ? 'At least one content item' : null;
                },
              ),
              SizedBox(height: 8.h),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active'),
                value: isActive,
                onChanged: (val) => setState(() => isActive = val),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: isSaving ? null : save,
          icon: isSaving
              ? SizedBox(
                  width: 16.w,
                  height: 16.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(Icons.save),
          label: Text(isSaving ? 'Saving...' : 'Save'),
        ),
      ],
    );
  }
}
