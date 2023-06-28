import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen>
    with SingleTickerProviderStateMixin {
  List<Widget> selectWidgets = [];
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: -200.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.addListener(() {
      setState(() {});
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          selectWidgets.removeAt(0);
        });
      }
    });
  }

  void _handleIconClick() {
    setState(() {
      selectWidgets.add(buildSelectWidget());
    });
    _animationController.forward(from: 0);
  }

  Widget buildSelectWidget() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _animation.value),
            child: FadeTransition(
              opacity: _animationController.drive(Tween(begin: 1.0, end: 0.0)),
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
            bottom: 0,
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
