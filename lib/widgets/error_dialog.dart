import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;
  const ErrorDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Center(
            child: Text("OK"),
          ),
        ),
      ],
    );
  }
}




 

Future<dynamic> onlodingDilog(BuildContext context,final String? message,  ) {
  
      return showDialog(
   context: context,
        builder: (BuildContext context) {
          return AlertDialog(

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            circularProgress(),
            const SizedBox(
              height: 10,
            ),
            Text("${message!},"),
          
            TextButton(onPressed: (){
                Navigator.pop(context);
            }, child:const Text('Ok'))
     

          ],
        ),
      );
        }
    );

}


 

circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12),
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Colors.amber,
      ),
    ),
  );
}
