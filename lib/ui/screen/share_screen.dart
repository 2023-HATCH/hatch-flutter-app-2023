import 'package:flutter/material.dart';
import 'package:pocket_pose/data/remote/provider/share_provider_impl.dart';
import 'package:provider/provider.dart';

class ShareScreen extends StatefulWidget {
  final String videoUuid;
  const ShareScreen({Key? key, required this.videoUuid}) : super(key: key);

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  late ShareProviderImpl _shareProvider;

  @override
  void initState() {
    _shareProvider = Provider.of<ShareProviderImpl>(context, listen: false);
    super.initState();
    _shareProvider = Provider.of<ShareProviderImpl>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.blue,
      body: FutureBuilder(
        future: _shareProvider.getVideoDetail(widget.videoUuid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.data!.data.title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  '${snapshot.data!.data.user.nickname} / ${snapshot.data!.data.tag}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            );
          }
          return const Text("로딩");
        },
      ),
    );
  }
}
