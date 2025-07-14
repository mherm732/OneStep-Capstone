/*import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 0.0,
            width: 829.0,
            top: 0.0, 
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffd5d1bf),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
          Positioned(
            right: 1, 
            top: 0, 
            bottom: 0, 
            width: 1090,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff1d2528),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
          Positioned(
            right: 279,
            top: MediaQuery.of(context).size.height*0.18,
            child: SvgPicture.string(
              _svg_gpvv1s,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
         Positioned(
            right: 223.0,
            width: 641.0,
            top: MediaQuery.of(context).size.height * 0.1766 - 53.0, 
            height: 106.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffe6e6e6),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff1d2528),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
         Positioned(
            right: 279.0,
            width: 530.0,
            top: MediaQuery.of(context).size.height * 0.1889 - 34.5, // 34.5 = 69 / 2
            height: 69.0,
            child: Text(
              'Create an account',
              style: TextStyle(
                fontFamily: 'JetBrainsMono Nerd Font',
                fontSize: 52,
                color: const Color(0xff1d2528),
                fontWeight: FontWeight.w600,
              ),
              softWrap: false,
            ),
          ),
            Positioned(
            right: 222.0,
            width: 641.0,
            top: MediaQuery.of(context).size.height * 0.3808 - 30.5, // 30.5 = 61 / 2
            height: 61.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffe6e6e6),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff1d2528),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 223.0,
            width: 500.0,
            top: MediaQuery.of(context).size.height * 0.474 - 30.5, // 30.5 = 61 / 2
            height: 61.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
          Positioned(
            right: 221.0,
            width: 642.0,
            top: MediaQuery.of(context).size.height * 0.474 - 30.5, // 61 / 2
            height: 61.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffe6e6e6),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff1d2528),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
         Positioned(
            right: 223.0,
            width: 640.0,
            top: MediaQuery.of(context).size.height * 0.5711 - 30.5, // 30.5 = 61 / 2
            height: 61.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffe6e6e6),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff1d2528),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.527, 0.46),
            child: SizedBox(
              width: 347.0,
              height: 61.0,
              child: SvgPicture.string(
                _svg_p75mml,
                allowDrawingOutsideViewBox: true,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.166, -0.199),
            child: SizedBox(
              width: 86.0,
              height: 96.0,
              child: Text(
                'Name\n',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono Nerd Font',
                  fontSize: 36,
                  color: const Color(0xff1d2528),
                ),
                softWrap: false,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.192, -0.004),
            child: SizedBox(
              width: 130.0,
              height: 96.0,
              child: Text(
                'E-mail\n',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono Nerd Font',
                  fontSize: 36,
                  color: const Color(0xff1d2528),
                ),
                softWrap: false,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.222, 0.191),
            child: SizedBox(
              width: 173.0,
              height: 96.0,
              child: Text(
                'Password\n',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono Nerd Font',
                  fontSize: 36,
                  color: const Color(0xff1d2528),
                ),
                softWrap: false,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.465, 0.448),
            child: SizedBox(
              width: 141.0,
              height: 36.0,
              child: Text(
                'Sign Up ',
                style: TextStyle(
                  fontFamily: 'Avenir Next LT Pro',
                  fontSize: 36,
                  color: const Color(0xff1d2528),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                ),
                softWrap: false,
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.2497 - 233.0, // 233 = 466 / 2
            width: 466.0,
            bottom: -8.0,
            height: 502.0,
            child: Text(
              'I',
              style: TextStyle(
                fontFamily: 'BigCheese OT Dark',
                fontSize: 500,
                color: const Color(0xff1d2528),
              ),
              softWrap: false,
            ),
          ),
          Align(
            alignment: Alignment(-0.636, 0.171),
            child: SizedBox(
              width: 301.0,
              height: 325.0,
              child: Text(
                'I',
                style: TextStyle(
                  fontFamily: 'BigCheese OT Dark',
                  fontSize: 323,
                  color: const Color(0xff1d2528),
                ),
                softWrap: false,
              ),
            ),
          ),
         Positioned(
            left: 190.0,
            width: 225.0,
            top: MediaQuery.of(context).size.height * 0.3919 - 121.5, // 243 / 2
            height: 243.0,
            child: Text(
              'I',
              style: TextStyle(
                fontFamily: 'BigCheese OT Dark',
                fontSize: 242,
                color: const Color(0xff1d2528),
              ),
              softWrap: false,
            ),
          ),
          Positioned(
            left: 105.0,
            width: 171.0,
            top: MediaQuery.of(context).size.height * 0.2637 - 92.5, // 185 / 2
            height: 185.0,
            child: Text(
              'I',
              style: TextStyle(
                fontFamily: 'BigCheese OT Dark',
                fontSize: 184,
                color: const Color(0xff1d2528),
              ),
              softWrap: false,
            ),
          ),
         Positioned(
            left: 50.0,
            width: 111.0,
            top: MediaQuery.of(context).size.height * 0.1729 - 60.0, // 120 / 2
            height: 120.0,
            child: Text(
              'I',
              style: TextStyle(
                fontFamily: 'BigCheese OT Dark',
                fontSize: 119,
                color: const Color(0xff1d2528),
              ),
              softWrap: false,
            ),
          ),
         Positioned(
            left: 13.0,
            width: 74.0,
            top: 119.6,
            height: 80.0,
            child: Text(
              'I',
              style: TextStyle(
                fontFamily: 'BigCheese OT Dark',
                fontSize: 80,
                color: const Color(0xff1d2528),
              ),
              softWrap: false,
            ),
          ),
          Align(
            alignment: Alignment(-1.0, 0.567),
            child: Container(
              width: 462.0,
              height: 91.0,
              decoration: BoxDecoration(
                color: const Color(0xff1d2528),
                border: Border.all(width: 5.0, color: const Color(0xffe6e6e6)),
              ),
            ),
          ),
          Positioned(
            left: 222.0,
            width: 224.0,
            top: MediaQuery.of(context).size.height * 0.7903 - 56.0, // 112 / 2
            height: 112.0,
            child: Text(
              'welcome',
              style: TextStyle(
                fontFamily: 'LoRes 28 OT',
                fontSize: 108,
                color: const Color(0xffd9f316),
              ),
              softWrap: false,
            ),
          ),
         Positioned(
            left: MediaQuery.of(context).size.width * 0.3664 - 99.0, // 198 / 2
            width: 198.0,
            top: 35.0,
            height: 212.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffd9f316),
                border: Border.all(width: 5.0, color: const Color(0xff1d2528)),
              ),
            ),
          ),
          Positioned(
            left: 259.0,
            width: 589.0,
            top: 65.0,
            height: 153.0,
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontFamily: 'Cholla OT',
                  fontSize: 139,
                  color: const Color(0xff1d2528),
                ),
                children: [
                  TextSpan(
                    text: 'One Step',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: ' ',
                  ),
                ],
              ),
              textHeightBehavior:
                  TextHeightBehavior(applyHeightToFirstAscent: false),
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_gpvv1s =
    '<svg viewBox="1019.6 119.6 714.9 806.9" ><path transform="translate(1019.57, 119.55)" d="M 0 0 L 714.862060546875 0 L 714.862060546875 806.8966064453125 L 0 806.8966064453125 L 0 0 Z" fill="#d5d1bf" stroke="#707070" stroke-width="1" stroke-linecap="butt" stroke-linejoin="round" /></svg>';
const String _svg_p75mml =
    '<svg viewBox="1201.0 744.0 347.0 61.0" ><path transform="translate(1201.0, 744.0)" d="M 0 0 L 347 0 L 347 61 L 0 61 L 0 0 Z" fill="#d9f316" stroke="#1d2528" stroke-width="5" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
*/