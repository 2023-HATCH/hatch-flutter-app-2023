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
              padding: const EdgeInsets.fromLTRB(14, 2, 0, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              child: TextField(
                cursorColor: Colors.white,
                controller: tec,
                focusNode: fn,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: widget.tagController.hasTags ? '' : "#포포 #댄스챌린지",
                  hintStyle: const TextStyle(
                      color: Colors.white,
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
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                color: AppColor.purpleColor,
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
