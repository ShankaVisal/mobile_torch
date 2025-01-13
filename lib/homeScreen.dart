import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isOn = false;
  late AnimationController controller;
  late Animation<Color?> bigButtonColorAnimation;
  late Animation<Color?> midButtonColorAnimation;
  late Animation<Color?> smallButtonColorAnimation;

  Color bigButtonColor = const Color(0xFF312C27);
  Color midButtonColor = const Color(0xFF484242);
  Color smallButtonColor = const Color(0xFF504847);

  bool isColorChanged = false;

  @override
  void initState() {
    super.initState();
    _checkTorchAvailability();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    bigButtonColorAnimation = ColorTween(
      begin: const Color(0xFF312C27),
      end: const Color(0xFFFF8E01).withOpacity(0.3),
    ).animate(controller);

    midButtonColorAnimation = ColorTween(
      begin: const Color(0xFF484242),
      end: const Color(0xFFFF8E01).withOpacity(0.4),
    ).animate(controller);

    smallButtonColorAnimation = ColorTween(
      begin: const Color(0xFF504847),
      end: const Color(0xFFFF8E01),
    ).animate(controller);

    controller.addListener(() {
      setState(() {
        bigButtonColor = bigButtonColorAnimation.value!;
        midButtonColor = midButtonColorAnimation.value!;
        smallButtonColor = smallButtonColorAnimation.value!;
      });
    });
  }

  Future<void> _checkTorchAvailability() async {
    try {
      await TorchLight.isTorchAvailable();
    } catch (e) {
      _showMessage('Could not check if the device has an available torch');
    }
  }

  Future<void> _toggleTorch() async {
    try {
      if (isOn) {
        await TorchLight.enableTorch();
      } else {
        await TorchLight.disableTorch();
      }
    } catch (_) {
      _showMessage('Could not toggle torch');
    }
  }

  void _toggleColorAnimation() {
    if (isColorChanged) {
      controller.reverse();
    } else {
      controller.forward();
    }
    isColorChanged = !isColorChanged;
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('ALERT', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold))),
          content: Center(child: Text(message, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: const Text('Flash App'),
      //   centerTitle: true,
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(height: 20),
            // Icon(
            //   isOn ? Icons.wb_sunny : Icons.wb_sunny_outlined,
            //   size: 100,
            //   color: isOn ? const Color(0xFFFF8E01) : const Color(0xFF504847),
            // ),
            // const SizedBox(height: 30),
            // Text(
            //   'Flashlight: ${isOn ? "ON" : "OFF"}',
            //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 90),
            Container(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleContainer(width: 300, height: 300, color: bigButtonColor),
                  CircleContainer(width: 260, height: 260, color: midButtonColor),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isOn = !isOn;
                      });
                      await _toggleTorch();
                      _toggleColorAnimation();
                    },
                    child: Icon(Icons.power_settings_new, size: 170, color: isOn ? Colors.white : Colors.white60),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: smallButtonColor,
                      foregroundColor: isOn ? const Color(0xFF504847) : const Color(0xFFFF8E01),
                      minimumSize: const Size(190, 190),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const CircleContainer({required this.width, required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
