import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:provider/provider.dart';

class StageLiveChatBarWidget extends StatefulWidget {
  const StageLiveChatBarWidget({super.key, required this.nickName});
  final String nickName;

  @override
  State<StageLiveChatBarWidget> createState() => _StageLiveChatBarWidgetState();
}

class _StageLiveChatBarWidgetState extends State<StageLiveChatBarWidget>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _inputFieldFocusNode = FocusNode();
  bool _isFireIconVisible = true;
  bool _isLeft = true;

  List<Widget> selectWidgets = [];
  final List<AnimationController> _animationControllers = [];
  final List<Animation<Offset>> _animations = [];

  late SocketStageProviderImpl _socketStageProvider;

  @override
  void initState() {
    super.initState();
    _socketStageProvider =
        Provider.of<SocketStageProviderImpl>(context, listen: false);
    _inputFieldFocusNode.addListener(() {
      setState(() {
        _isFireIconVisible = (_inputFieldFocusNode.hasFocus) ? false : true;
      });
    });
  }

  @override
  void dispose() {
    for (final animationController in _animationControllers) {
      animationController.dispose();
    }
    _textController.dispose();
    _inputFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 실시간 반응
    var isReaction = context.select<SocketStageProviderImpl, bool>(
        (provider) => provider.isReaction);
    if (isReaction) {
      _socketStageProvider.setIsReaction(false);
      _handleIconClick();
    }

    return _buildInputArea(context);
  }

  Widget _buildInputArea(BuildContext context) {
    return Stack(
      children: [
        _buildLiveChatBar(context),
        ...selectWidgets,
      ],
    );
  }

  Container _buildLiveChatBar(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.fromLTRB(14, 0, 0, 2),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    controller: _textController,
                    cursorColor: Colors.white,
                    focusNode: _inputFieldFocusNode,
                    decoration: InputDecoration(
                      hintText: '${widget.nickName}(으)로 댓글 달기...',
                      hintStyle:
                          const TextStyle(color: Colors.white70, fontSize: 14),
                      labelStyle: const TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.next,
                    onSubmitted: (value) {
                      _socketStageProvider.sendMessage(value);
                      _textController.clear();
                    },
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isFireIconVisible ? 20 : 0,
              child: Visibility(
                visible: _isFireIconVisible,
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () => _socketStageProvider.sendReaction(),
                  child: SvgPicture.asset(
                      'assets/icons/ic_popo_fire_unselect.svg'),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isFireIconVisible ? 14 : 0,
              child: Visibility(
                visible: _isFireIconVisible,
                child: const InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: SizedBox(
                      width: 14,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleIconClick() {
    setState(() {
      _isLeft = !_isLeft;

      final animationController = AnimationController(
        duration: const Duration(milliseconds: 4000),
        vsync: this,
      );

      const beginOffset = Offset(0.0, 0.0);
      final middleOffset =
          _isLeft ? const Offset(-8.0, -100.0) : const Offset(8.0, -100.0);
      const endOffset = Offset(0.0, -200.0);

      final animation = TweenSequence([
        TweenSequenceItem(
          tween: Tween<Offset>(begin: beginOffset, end: middleOffset),
          weight: 0.5,
        ),
        TweenSequenceItem(
          tween: Tween<Offset>(begin: middleOffset, end: endOffset),
          weight: 0.5,
        ),
      ]).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ));
      animationController.addListener(() {
        setState(() {});
      });

      animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            selectWidgets.removeAt(0);
            _animationControllers.removeAt(0);
            _animations.removeAt(0);
          });
        }
      });

      selectWidgets.add(_buildSelectWidget(
        selectWidgets.length,
        animationController,
        animation,
      ));
      _animationControllers.add(animationController);
      _animations.add(animation);
    });

    _animationControllers.last.forward(from: 0);
  }

  Widget _buildSelectWidget(int index, AnimationController animationController,
      Animation<Offset> animation) {
    return Positioned(
      bottom: 14,
      right: 0,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              animation.value.dx,
              animation.value.dy,
            ),
            child: FadeTransition(
              opacity: animationController.drive(Tween(begin: 1.0, end: 0.0)),
              child: child,
            ),
          );
        },
        child: Image.asset(
          'assets/icons/ic_popo_fire_select.png',
          height: 50,
        ),
      ),
    );
  }
}
