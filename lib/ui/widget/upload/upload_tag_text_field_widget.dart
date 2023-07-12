import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/ui/widget/upload/custom_tag_text_field_controller.dart';
import 'package:textfield_tags/textfield_tags.dart';

class UploadTagTextFieldWidget extends StatefulWidget {
  const UploadTagTextFieldWidget(
      {super.key,
      required this.tagController,
      required this.setIsTagsFillPutState});
  final CustomTagTextFieldController tagController;
  final Function setIsTagsFillPutState;

  @override
  State<UploadTagTextFieldWidget> createState() =>
      _UploadTagTextFieldWidgetState();
}

class _UploadTagTextFieldWidgetState extends State<UploadTagTextFieldWidget> {
  late double _distanceToField;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldTags(
      textfieldTagsController: widget.tagController,
      textSeparators: const [' ', ','],
      letterCase: LetterCase.normal,
      validator: (String tag) {
        widget.setIsTagsFillPutState(true);
        return null;
      },
      inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
        return ((context, sc, tags, onTagDelete) {
          return Expanded(
            child: Container(
              height: 40,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColor.grayColor2,
                  width: 2.5,
                ),
              ),
              child: TextField(
                controller: tec,
                focusNode: fn,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: widget.tagController.hasTags ? '' : "#포포 #댄스챌린지",
                  hintStyle: TextStyle(
                      color: AppColor.blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                  errorText: error,
                  prefixIconConstraints:
                      BoxConstraints(maxWidth: _distanceToField * 0.54),
                  prefixIcon: tags.isNotEmpty
                      ? SingleChildScrollView(
                          controller: sc,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: tags.map((String tag) {
                            return Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                color: Colors.grey,
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    child: Text(
                                      '#$tag',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  InkWell(
                                    child: const Icon(
                                      Icons.cancel,
                                      size: 14.0,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      onTagDelete(tag);
                                    },
                                  )
                                ],
                              ),
                            );
                          }).toList()),
                        )
                      : null,
                ),
                onChanged: onChanged,
                onSubmitted: onSubmitted,
              ),
            ),
          );
        });
      },
    );
  }
}
