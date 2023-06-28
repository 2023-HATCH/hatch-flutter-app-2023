import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen>
    with TickerProviderStateMixin {
  List<Widget> selectWidgets = [];
  final List<AnimationController> _animationControllers = [];
  final List<Animation<double>> _animations = [];

  @override
  void dispose() {
    for (final animationController in _animationControllers) {
      animationController.dispose();
    }
    super.dispose();
  }

  void _handleIconClick() {
    setState(() {
      final animationController = AnimationController(
        duration: const Duration(milliseconds: 3000),
        vsync: this,
      );

      final animation = Tween(begin: 0.0, end: -200.0).animate(CurvedAnimation(
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
            debugPrint("${selectWidgets.length} 위젯 소멸");
          });
        }
      });

      selectWidgets.add(buildSelectWidget(
          selectWidgets.length, animationController, animation));
      _animationControllers.add(animationController);
      _animations.add(animation);

      debugPrint("${selectWidgets.length} 위젯 생성");
    });

    _animationControllers.last.forward(from: 0);
  }

  Widget buildSelectWidget(int index, AnimationController animationController,
      Animation<double> animation) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, animation.value),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [
          Positioned(
            bottom: 12,
            right: 12,
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: _handleIconClick,
              child: SvgPicture.asset('assets/icons/ic_popo_fire_unselect.svg'),
            ),
          ),
          ...selectWidgets,
        ],
      ),
    );
  }
}
