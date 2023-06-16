import 'package:flutter/material.dart';
import 'package:pocket_pose/ui/screen/popo_wait_screen.dart';

class PoPoResultScreen extends StatelessWidget {
  const PoPoResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/bg_popo_comm.png'),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const PoPoWaitScreen()));
                },
                icon: const Icon(Icons.navigate_next_rounded))
          ],
        ),
        body: const Text(
          "결과",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
