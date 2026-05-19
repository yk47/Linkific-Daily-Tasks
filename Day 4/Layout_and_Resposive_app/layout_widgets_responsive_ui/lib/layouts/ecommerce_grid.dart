import 'package:flutter/material.dart';

class EcommerceGrid extends StatelessWidget {
  const EcommerceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        childAspectRatio: 0.75,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
      ),
      itemCount: 100,
      itemBuilder: (context, index) {
        return ProductCard(productIndex: index + 1);
      },
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 900) {
      return 4;
    } else if (width > 600) {
      return 3;
    } else {
      return 2;
    }
  }
}

class ProductCard extends StatefulWidget {
  final int productIndex;

  const ProductCard({super.key, required this.productIndex});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: Colors.grey[300],
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.shopping_bag,
                      size: 50,
                      color: Colors.grey[600],
                    ),
                  ),
                  // Discount badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-${10 + widget.productIndex % 30}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Product info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Product ${widget.productIndex}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        return Icon(
                          i < (4 + widget.productIndex % 2)
                              ? Icons.star
                              : Icons.star_border,
                          size: 14,
                          color: Colors.amber,
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        '(${50 + widget.productIndex})',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '\$${(widget.productIndex * 10).toString()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${(widget.productIndex * 13).toString()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
