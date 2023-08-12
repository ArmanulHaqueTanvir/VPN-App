import 'package:flutter/material.dart';
import 'package:vpn/servers.dart';

class VPNScreen extends StatefulWidget {
  const VPNScreen({super.key});

  @override
  State<VPNScreen> createState() => _VPNScreenState();
}

class _VPNScreenState extends State<VPNScreen> with TickerProviderStateMixin {
  late AnimationController _headAnimationController;
  late AnimationController _sideAnimationController;
  late Animation<Offset> _headController;
  late Animation<Offset> _leftSideController;
  late Animation<Offset> _rightSideController;
  late Animation<double> _headImageController;
  late Animation<double> _sideImageController;

  bool connected = false;
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    _headAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 1500,
        ));

    _sideAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 1800,
        ));
    _headController =
        Tween<Offset>(begin: const Offset(0, -2.5), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _headAnimationController, curve: Curves.easeInOut));

    _leftSideController =
        Tween<Offset>(begin: const Offset(-2, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _sideAnimationController, curve: Curves.easeInOut));

    _rightSideController =
        Tween<Offset>(begin: const Offset(2, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _sideAnimationController, curve: Curves.easeInOut));

    _headImageController = Tween<double>(
      begin: 0.2,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _headAnimationController,
      curve: Curves.easeInOut,
    ));

    _sideImageController = Tween<double>(
      begin: 0.1,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _headAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _headAnimationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _sideAnimationController.reset();
    _headAnimationController.reset();
    _headAnimationController.forward();
    _sideAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF151422),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 30,
                              ),
                              Text(
                                "VPN Proxy Master",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(width: 180),
                            ],
                          ),
                          const SizedBox(height: 50),
                          SizedBox(
                            width: 300,
                            height: 235,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if (showLoading)
                                      Container(
                                        width: connected ? 225 : 250,
                                        height: connected ? 225 : 250,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff151422),
                                        ),
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Color(0xff39acc1)),
                                        ),
                                      ),
                                    Image.asset(
                                      'assets/images/world.png',
                                      width: 200,
                                      height: 200,
                                    ),
                                  ],
                                ),
                                Positioned(
                                  child: SlideTransition(
                                    position: _headController,
                                    child: Image.asset(
                                      'assets/images/head.png',
                                      opacity: _headImageController,
                                      width: 200,
                                      height: 160,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  child: SlideTransition(
                                    position: _headController,
                                    child: Image.asset(
                                      'assets/images/head.png',
                                      opacity: _headImageController,
                                      width: 200,
                                      height: 160,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 40,
                                  top: 28,
                                  child: SlideTransition(
                                    position: _rightSideController,
                                    child: Image.asset(
                                      'assets/images/right.png',
                                      opacity: _sideImageController,
                                      // width: 200,
                                      height: 195,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 40,
                                  top: 28,
                                  child: SlideTransition(
                                    position: _leftSideController,
                                    child: Image.asset(
                                      'assets/images/left.png',
                                      opacity: _sideImageController,
                                      // width: 200,
                                      height: 195,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                          GestureDetector(
                            onTap: () {
                              if (!connected) {
                                Future.delayed(
                                    const Duration(milliseconds: 2000), () {
                                  _startAnimation();
                                  setState(() {
                                    showLoading = !showLoading;
                                  });
                                });
                              } else {
                                Future.delayed(
                                    const Duration(milliseconds: 2000), () {
                                  _sideAnimationController.reverse();
                                  _headAnimationController.reverse();
                                  setState(() {
                                    showLoading = !showLoading;
                                  });
                                });
                              }
                              setState(() {
                                showLoading = !showLoading;
                                connected = !connected;
                              });
                            },
                            child: Container(
                              width: 200,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xff20202d),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xffa2a2ae),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  connected ? "Disconnect" : "Connect",
                                  style: const TextStyle(
                                      color: Color(0xffa2a2ae), fontSize: 18),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // DraggableScrollableSheet(
            //   builder: (BuildContext context, scrollController) {
            //     return Container();
            //   },
            // ),

            DraggableScrollableSheet(
              initialChildSize: 0.185,
              minChildSize: 0.185,
              maxChildSize: 0.5,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Color(0xff20202d),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 60,
                        height: 10,
                        decoration: const BoxDecoration(
                            color: Color(0xff151422),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          controller: scrollController,
                          itemCount: servers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Image.asset(
                                servers[index]['image'].toString(),
                                width: 40,
                              ),
                              title: Text(
                                servers[index]['country'].toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: Text(
                                servers[index]['ip'].toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
