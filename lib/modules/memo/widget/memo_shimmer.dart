import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MemoShimmer extends StatelessWidget {
  const MemoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShimmerBox(width: double.infinity, height: 60),
            const SizedBox(height: 16),
            _buildShimmerBox(width: 150, height: 20),
            const SizedBox(height: 16),
            _buildShimmerBox(width: 100, height: 20),
            const SizedBox(height: 8),
            _buildShimmerBox(width: double.infinity, height: 40),
            const SizedBox(height: 16),
            _buildShimmerBox(width: 100, height: 20),
            const SizedBox(height: 8),
            _buildShimmerBox(width: double.infinity, height: 40),
            const SizedBox(height: 16),
            _buildShimmerBox(width: 150, height: 20),
            const SizedBox(height: 8),
            _buildShimmerBox(width: double.infinity, height: 40),
            const SizedBox(height: 16),
            _buildShimmerBox(width: 100, height: 20),
            const SizedBox(height: 8),
            _buildShimmerBox(width: double.infinity, height: 40),
            const SizedBox(height: 16),
            _buildShimmerBox(width: 100, height: 20),
            const SizedBox(height: 8),
            _buildShimmerBox(width: double.infinity, height: 40),
            const SizedBox(height: 16),
            _buildShimmerBox(width: 100, height: 20),
            const SizedBox(height: 8),
            _buildShimmerBox(width: double.infinity, height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerBox({required double width, required double height, double radius = 16}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}