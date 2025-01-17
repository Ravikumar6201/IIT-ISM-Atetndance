import 'package:flutter/material.dart';
import 'package:ism/Class/Colorconstat.dart';

class ProfessorClass extends StatefulWidget {
  const ProfessorClass({super.key});

  @override
  State<ProfessorClass> createState() => _ProfessorClassState();
}

class _ProfessorClassState extends State<ProfessorClass> {
  final List<String> items = List<String>.generate(10, (i) => "Item $i");

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ColorConstant.ismcolor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Active Classes",
                  style:
                      TextStyle(fontSize: 20, color: ColorConstant.whiteA700),
                ),
              ),
              const SizedBox(
                  height:
                      10), // Add some spacing between the title and the list
              Container(
                height: constraints.maxHeight -
                    50, // Adjust the height based on the available space
                width: double.infinity,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        items[index],
                        style: TextStyle(color: ColorConstant.whiteA700),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       color: ColorConstant.ismcolor,
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Column(
  //       children: [
  //         Center(child: Text("Active Classes",style: TextStyle(fontSize: 20,color: ColorConstant.whiteA700),)),
  //         Container(height: 200,
  //         width: double.infinity,
  //           child: ListView.builder(
  //             itemCount: items.length,
  //             shrinkWrap: true,
  //             itemBuilder: (context, index) {
  //               return ListTile(
  //                 title: Text(items[index],style: TextStyle(color: ColorConstant.whiteA700),),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
