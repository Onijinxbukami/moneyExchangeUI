import 'package:flutter/material.dart';

class ProgressStepper extends StatefulWidget {
  final List<String> steps; // Danh sách các bước
  final int currentStep; // Bước hiện tại (0-based)
  final Color backgroundColor; // Màu nền progress bar
  final Color progressColor; // Màu phần hoàn thành
  final double height; // Chiều cao progress bar

  const ProgressStepper({
    Key? key,
    required this.steps,
    required this.currentStep,
    this.backgroundColor = Colors.grey,
    this.progressColor = const Color(0xFF4743C9),
    this.height = 8.0,
  }) : super(key: key);

  @override
  _ProgressStepperState createState() => _ProgressStepperState();
}

class _ProgressStepperState extends State<ProgressStepper> {
  @override
  Widget build(BuildContext context) {
    double progress = (widget.currentStep + 1) / widget.steps.length;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        // Thanh tiến trình
        Container(
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress, // Tỉ lệ tiến trình
              backgroundColor: widget.backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(widget.progressColor),
              minHeight: widget.height,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Danh sách các bước
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.steps.asMap().entries.map((entry) {
            final index = entry.key;
            final stepLabel = entry.value;
            final isActive = index == widget.currentStep;
            final isCompleted = index < widget.currentStep;

            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Bước
                  GestureDetector(
                    onTap: isCompleted
                        ? () {
                            // Xử lý khi nhấn vào bước đã hoàn thành
                          }
                        : null,
                    child: Container(
                      width: screenWidth * 0.05, // Responsive kích thước
                      height: screenWidth * 0.05,
                      decoration: BoxDecoration(
                        color: isActive
                            ? widget.progressColor
                            : (isCompleted ? Colors.green : widget.backgroundColor),
                        shape: BoxShape.circle,
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Nhãn bước
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      stepLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.03, // Responsive font size
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isActive
                            ? Colors.black
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
