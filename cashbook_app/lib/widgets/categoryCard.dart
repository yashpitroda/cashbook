import 'package:cashbook_app/models/category.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);
  final Category_ category;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 130,
      decoration: BoxDecoration(
          color:const Color.fromARGB(255, 234, 242, 247),
          borderRadius: BorderRadius.circular(6)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            category.categoryName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue[700],
            ),
          ),
        ),
      ),
    );
  }
}
