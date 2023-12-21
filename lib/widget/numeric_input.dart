import 'package:flutter/material.dart';

class NumericStepButton extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int incrementVal;
  int counter;
  final void Function(int) onChanged;

  NumericStepButton(
      {Key? key,
      this.minValue = 0,
      this.maxValue = 12,
      this.incrementVal = 22000,
      required this.counter,
      required this.onChanged})
      : super(key: key);

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.remove,
              color: Theme.of(context).accentColor,
            ),
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
            iconSize: 32.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                if (widget.counter > widget.minValue) {
                  widget.counter -= widget.incrementVal;
                }
                print("Counter Value" + widget.counter.toString());
              });
              widget.onChanged(widget.counter);
            },
          ),
          Expanded(
              child: Text(
            widget.counter.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
          )),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).accentColor,
            ),
            padding: EdgeInsets.only(left: 4.0, top: 18.0, bottom: 18.0),
            iconSize: 32.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                if (widget.counter < widget.maxValue) {
                  widget.counter += widget.incrementVal;
                }
              });
              widget.onChanged(widget.counter);
            },
          ),
        ],
      ),
    );
  }
}
