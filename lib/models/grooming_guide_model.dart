import 'package:flutter/material.dart';

/// Model representing a men's grooming educational article
class GroomingArticle {
  final String id;
  final String title;
  final String category; // Hair Care, Beard Maintenance, Styling & Tools, Growth
  final String readTime;
  final String summary;
  final IconData icon;
  final List<String> keyTips;
  final String fullContent;

  const GroomingArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.readTime,
    required this.summary,
    required this.icon,
    required this.keyTips,
    required this.fullContent,
  });
}
