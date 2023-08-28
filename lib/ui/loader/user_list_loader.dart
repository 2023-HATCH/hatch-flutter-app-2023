import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:shimmer/shimmer.dart';

class UserListLoader extends StatelessWidget {
  const UserListLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Shimmer.fromColors(
      baseColor: AppColor.grayColor4,
      highlightColor: const Color.fromARGB(255, 230, 230, 230),
      child: Container(
        padding: const EdgeInsets.all(18),
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.yellow,
                height: 50,
                width: 50,
              ),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.all(14),
                  color: AppColor.blueColor2,
                  height: 15,
                  width: 100,
                ),
                const SizedBox(height: 14),
                Container(
                  color: Colors.pink,
                  height: 15,
                  width: 200,
                ),
              ])
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.yellow,
                height: 50,
                width: 50,
              ),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.all(14),
                  color: Colors.pink,
                  height: 15,
                  width: 100,
                ),
                const SizedBox(height: 14),
                Container(
                  color: Colors.pink,
                  height: 15,
                  width: 200,
                ),
              ])
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.yellow,
                height: 50,
                width: 50,
              ),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.all(14),
                  color: Colors.pink,
                  height: 15,
                  width: 100,
                ),
                const SizedBox(height: 14),
                Container(
                  color: Colors.pink,
                  height: 15,
                  width: 200,
                ),
              ])
            ],
          ),
        ]),
      ),
    ));
  }
}
