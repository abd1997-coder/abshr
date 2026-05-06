import 'package:flutter/material.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/constants/app_strings.dart';
import 'package:marketplace/core/widgets/widgets.dart';
import 'package:marketplace/features/home/data/models/offer_model.dart';
import 'package:marketplace/features/home/domain/entities/category.dart';
import 'package:marketplace/features/home/presentation/pages/all_sellers_page.dart';

class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage({super.key, required this.categories});

  final List<Category> categories;

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orangeColor = AppConstants.primaryColor;
    final darkGreyColor = Colors.grey.shade800;
    final query = _searchController.text.trim().toLowerCase();
    final categories =
        query.isEmpty
            ? widget.categories
            : widget.categories
                .where(
                  (category) => category.name.toLowerCase().contains(query),
                )
                .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: darkGreyColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppStrings.allCategories,
          style: TextStyle(
            color: darkGreyColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          SizedBox(
            height: 48,
            child: AppTextField(
              controller: _searchController,
              hintText: AppStrings.allCategories,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade600,
                size: 22,
              ),
              suffixIcon:
                  _searchController.text.trim().isNotEmpty
                      ? GestureDetector(
                        onTap: _searchController.clear,
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.grey.shade600,
                        ),
                      )
                      : null,
            ),
          ),
          const SizedBox(height: 18),
          if (categories.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 56),
              child: Column(
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 56,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    AppStrings.noProductsInCategory,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.92,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return _CategoryTile(
                  category: category,
                  orangeColor: orangeColor,
                  darkGreyColor: darkGreyColor,
                );
              },
            ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.orangeColor,
    required this.darkGreyColor,
  });

  final Category category;
  final Color orangeColor;
  final Color darkGreyColor;

  @override
  Widget build(BuildContext context) {
    final rawImage = category.imageUrl.trim();
    final imageUrl =
        rawImage.isEmpty ? '' : OfferModel.resolveAbsoluteUrl(rawImage);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AllSellersPage(initialCategory: category),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child:
                      imageUrl.isNotEmpty
                          ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) =>
                                    _FallbackIcon(orangeColor: orangeColor),
                          )
                          : _FallbackIcon(orangeColor: orangeColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: darkGreyColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: orangeColor,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  const _FallbackIcon({required this.orangeColor});

  final Color orangeColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: orangeColor.withValues(alpha: 0.10),
      child: Icon(
        Icons.category_outlined,
        color: orangeColor,
        size: 44,
      ),
    );
  }
}
