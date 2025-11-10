import 'package:flutter/material.dart';

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const FaqItem(this.question, this.answer, {super.key});

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.question.replaceFirst(RegExp(r'^\d+\.\s*'), ''),
                      style: TextStyle(
                        fontSize: 14,

                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded,size: 30,),
                ],
              )
,

              if (_isExpanded) ...[
                const SizedBox(height: 10),
                Text(
                  widget.answer,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                    height: 1.5,

                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
