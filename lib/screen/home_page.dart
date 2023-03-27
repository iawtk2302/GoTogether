import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 210,
            width: double.infinity,
            color: Colors.green,
            child: Column(children: [
              SizedBox(
                height: MediaQuery.of(context).viewPadding.top,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Go together',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                        Text(
                          'Find in minute',
                          style: TextStyle(
                              // fontWeight: FontWeight.w600,
                              // fontSize: 18,
                              color: Colors.white.withOpacity(0.7)),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white.withOpacity(0.4), width: 0.5),
                          borderRadius: BorderRadius.circular(50)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 4, top: 4, bottom: 4),
                        child: Row(children: const [
                          Icon(Icons.menu, color: Colors.white),
                          SizedBox(
                            width: 16,
                          ),
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                'https://firebasestorage.googleapis.com/v0/b/sneakerapp-f4de5.appspot.com/o/RWN1mUAm9FXdowlsgKbZqU25zt23.jpg?alt=media&token=0df163e4-3a98-4371-90a7-52ec17c26320'),
                          )
                        ]),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(8),
                width: size.width - 60,
                height: 95,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 12),
                        child: Text(
                          'Where did you go?',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.arrow_circle_right_rounded,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                              child: TextField(
                                cursorColor: Colors.green,
                            decoration: InputDecoration(
                              hintText: 'Search location',
                              hintStyle: TextStyle(fontSize: 12),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 1)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 1)),
                              
                            ),
                          )),
                        ],
                      ))
                    ]),
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 210.0),
            child: Container(
              height: MediaQuery.of(context).size.height - 210,
              width: double.infinity,
              // color: Colors.red,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12),
                  child: Column(children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Recommend for you',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                    ),
                    ListView.separated(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => itemRender(),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemCount: 5)
                  ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget itemRender() {
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () {},
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 230,
            width: double.infinity,
            child: Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl:
                            'https://6f3ebe2ff971707.cmccloud.com.vn/tour/wp-content/uploads/2022/03/202005171129SA19.jpeg',
                      ),
                    )),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quy Nhơn, Bình Định',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: const [Icon(Icons.star), Text('4.1')],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              'Cách 1 km',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              'Ngày 20 - 23 , Tháng 2',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
