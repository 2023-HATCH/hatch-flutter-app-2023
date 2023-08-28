import 'package:flutter/widgets.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:shimmer/shimmer.dart';

class SearchTextFieldLoader extends StatelessWidget {
  const SearchTextFieldLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.grayColor4,
      highlightColor: const Color.fromARGB(255, 255, 255, 255),
      child: Column(
        children: [
          const SizedBox(
            height: 4,
          ),
          Row(
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(left: 18)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColor.grayColor4),
                      height: 35,
                    )),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 18)),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
