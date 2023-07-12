import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

class UploadTagTextFieldWidget extends StatefulWidget {
  const UploadTagTextFieldWidget({super.key});

  @override
  State<UploadTagTextFieldWidget> createState() =>
      _UploadTagTextFieldWidgetState();
}

class _UploadTagTextFieldWidgetState extends State<UploadTagTextFieldWidget> {
  late double _distanceToField;
  late TextfieldTagsController _tagController;

  @override
  void initState() {
    _tagController = TextfieldTagsController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldTags(
      textfieldTagsController: _tagController,
      textSeparators: const [' ', ','],
      letterCase: LetterCase.normal,
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
                  color: Colors.grey,
                  width: 2.5,
                ),
              ),
              child: TextField(
                controller: tec,
                focusNode: fn,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: _tagController.hasTags ? '' : "#포포 #댄스챌린지",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
