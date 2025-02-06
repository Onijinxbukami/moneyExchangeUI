import 'package:flutter/material.dart';

class ProgressStepper extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final Color backgroundColor;
  final Color progressColor;
  final double height;

  const ProgressStepper({
    Key? key,
    required this.steps,
    required this.currentStep,
    this.backgroundColor = Colors.grey,
    this.progressColor = const Color(0xFF4743C9),
    this.height = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double progress = (currentStep + 1) / steps.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thanh tiến trình với animation
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              // Phần tiến trình hoàn thành
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Danh sách bước với đường nối
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length, (index) {
            final isActive = index == currentStep;
            final isCompleted = index < currentStep;

            return Expanded(
              child: Column(
                children: [
                  // Bước có hiệu ứng động
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (index != 0) // Đường nối giữa các bước
                        Positioned(
                          left: -screenWidth * 0.05,
                          right: 0,
                          child: Container(
                            height: 4,
                            color:
                                isCompleted ? progressColor : backgroundColor,
                          ),
                        ),
                      GestureDetector(
                        onTap: isCompleted
                            ? () {
                                // Xử lý khi nhấn vào bước đã hoàn thành
                              }
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isActive
                              ? screenWidth * 0.07
                              : screenWidth * 0.06,
                          height: isActive
                              ? screenWidth * 0.07
                              : screenWidth * 0.06,
                          decoration: BoxDecoration(
                            color: isActive
                                ? progressColor
                                : (isCompleted
                                    ? Colors.green
                                    : backgroundColor),
                            shape: BoxShape.circle,
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: progressColor.withOpacity(0.4),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                          ),
                          child: isCompleted
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 18)
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Nhãn của bước
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      steps[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal,
                        color: isActive ? Colors.black87 : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
