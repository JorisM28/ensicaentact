import 'package:flutter/material.dart';
import '/service_locator.dart';
import '/View/theme/colors.dart';
import '/View/screens/event/news_page.dart';
import '/l10n/app_localizations.dart';
import '/ViewModel/event/news_viewmodel.dart';

class ActualityWidget extends StatefulWidget {
  final VoidCallback? onAddPress;

  const ActualityWidget({super.key, this.onAddPress});

  @override
  State<ActualityWidget> createState() => _ActualityWidgetState();
}

class _ActualityWidgetState extends State<ActualityWidget> {
  late final NewsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<NewsViewModel>();
    _viewModel.loadData();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }


  void _confirmerSuppression(Map<String, dynamic> item) {
    final traductions = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(traductions.directoryDeleteConfirmTitle),
        content: Text(traductions.directoryDeleteConfirmContent(item['titre'] ?? traductions.untitled)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(traductions.cancel)),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);

              var rawId = item['id_actu'];
              if (rawId == null) {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(traductions.errorOccurred)));
                return;
              }

              bool success = await _viewModel.deleteNews(int.parse(rawId.toString()));

              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(traductions.newsDeletedSuccess))
                );
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(traductions.errorOccurred))
                );
              }
            },
            child: Text(traductions.deleteBtn, style: const TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  Color _parseColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) return const Color(0xFF67CBB8);
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return const Color(0xFF67CBB8);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_viewModel.isLoading) return const Center(child: CircularProgressIndicator());

    final traductions = AppLocalizations.of(context)!;
    final displayList = _viewModel.news.take(2).toList();
    final isAdmin = _viewModel.isAdmin;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isAdmin && widget.onAddPress != null) ...[
                const Spacer(),
              ],
              Text(
                traductions.drawerNews.toUpperCase(),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.ensiCyan),
              ),
              if (isAdmin && widget.onAddPress != null) ...[
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: AppColors.ensiCyan, size: 24),
                  onPressed: widget.onAddPress,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: traductions.addNewsTooltip,
                )
              ]
            ],
          ),
        ),

        Expanded(
          child: displayList.isEmpty
              ? Center(child: Text(traductions.noNewsAvailable))
              : Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildAdaptiveCard(displayList[0], isAdmin, traductions)),
              const SizedBox(width: 20),
              Expanded(
                child: displayList.length > 1
                    ? _buildAdaptiveCard(displayList[1], isAdmin, traductions)
                    : const SizedBox(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        OutlinedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsPage())),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFE30613)),
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: Text(traductions.seeAllNews, style: const TextStyle(color: Color(0xFFE30613))),
        ),
      ],
    );
  }

  Widget _buildAdaptiveCard(Map<String, dynamic> item, bool estAdmin, AppLocalizations traductions) {
    final String title = item['titre'] ?? traductions.untitled;
    final String tag = item['tag'] ?? "NEWS";
    final Color tagColor = _parseColor(item['tag_color']);
    final String? imageUrl = item['image_url'];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewspaperDetailsPage(item: item))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: (imageUrl != null && imageUrl.isNotEmpty)
                      ? Image.network(imageUrl, fit: BoxFit.cover)
                      : const Center(child: Icon(Icons.image, size: 40, color: Colors.grey)),
                ),
                if (estAdmin)
                  Positioned(
                    top: 8, right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.white, radius: 14,
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 16),
                        onPressed: () => _confirmerSuppression(item),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white24,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: tagColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(tag.toUpperCase(), style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, height: 1.2), maxLines: 3, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
