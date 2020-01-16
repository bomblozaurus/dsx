import 'package:flutter/material.dart';

class SimpleStep {
  final String title;
  final String subtitle;
  final Widget content;

  SimpleStep({
    this.title,
    this.content,
    this.subtitle,
  });

  static Step toStep(int index, SimpleStep step, int currentStep,
      {Brightness brightness}) {
    return Step(
        title: Text(step.title),
        subtitle: _buildSubtitle(step),
        isActive: index == currentStep,
        state: currentStep > index
            ? StepState.complete
            : currentStep < index ? StepState.indexed : StepState.editing,
        content: step.content);
  }

  static Widget _buildSubtitle(SimpleStep step) =>
      step.subtitle != null ? Text(step.subtitle) : null;
}
