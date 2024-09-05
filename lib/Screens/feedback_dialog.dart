import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ni_service/model/requestFeedback.dart';
import 'package:ni_service/model/responseGetServiceRequestList.dart';

import '../http_service/services.dart';

class FeedbackDialog extends StatefulWidget {
  final DataComplaintsList complaint;
  bool isLoading;
  final Function(String) callback;

  FeedbackDialog(this.complaint, this.isLoading,
      {super.key, required this.callback});

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  int _selectedRating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
          child: Text(
        "Feedback",
        style: TextStyle(color: Colors.green),
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Center(child: Text("Rate your experience:")),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final starNumber = index + 1;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRating = starNumber;
                  });
                },
                child: Icon(
                  Icons.star,
                  color: starNumber <= _selectedRating
                      ? Colors.yellow
                      : Colors.grey,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          const Text("Comment:"),
          TextField(
            controller: _feedbackController,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: "Write your feedback here...",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              final int rating = _selectedRating;
              final String feedback = _feedbackController.text;
              if (rating != 0 && feedback.isNotEmpty) {
                RequestFeedback requestFeedback = RequestFeedback();
                requestFeedback.customerId = widget.complaint.customerId?.sId;
                requestFeedback.serviceRequestId = widget.complaint.sId;
                requestFeedback.count = rating.toString();
                requestFeedback.feedback = feedback;
                final responseFeedback =
                    await sendFeedbackRequest(requestFeedback);
                if (responseFeedback.message != null &&
                    responseFeedback.message != "" &&
                    responseFeedback.message ==
                        "Feedback saved Successfully!!") {
                  widget.callback("200");
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(responseFeedback.message!)));

                  if (kDebugMode) {
                    print("Rating: $rating");
                  }
                  if (kDebugMode) {
                    print("Feedback: $feedback");
                  }

                  Navigator.of(context).pop();
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please enter required fields")));
              }
            } catch (e) {
              if (kDebugMode) {
                print(e.toString());
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Background color
          ),
          child: const Text(
            "Submit",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
