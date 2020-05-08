import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fastcash/registerFirstPage.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  Function goToTab;

  List<Slide> slides = new List();

  final storage = new FlutterSecureStorage();

  introViewed() async {
    await storage.write(key: "intro", value: "viewed");
  }

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "A FASTER, SAFER WAY TO PAY",
        styleTitle: TextStyle(
            color: Color(0xffffffff),
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Add a payment method to our app to get started with FAST CASH",
        pathImage: "images/intro1.png",
        styleDescription: TextStyle(
            color: Color(0xfffffffff), fontSize: 15.0, fontFamily: 'Raleway'),
      ),
    );
    slides.add(
      new Slide(
        title: "EASILY MANAGE YOUR INFO",
        styleTitle: TextStyle(
            color: Color(0xffffffff),
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description: "Protected with multiple layers of security",
        pathImage: "images/intro2.png",
        styleDescription: TextStyle(
            color: Color(0xfffffffff), fontSize: 15.0, fontFamily: 'Raleway'),
      ),
    );
    slides.add(
      new Slide(
        title: "PAY, MANAGE, GROW",
        styleTitle: TextStyle(
            color: Color(0xffffffff),
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "An easy app to manage all your payment and finance related needs",
        pathImage: "images/intro3.png",
        styleDescription: TextStyle(
            color: Color(0xfffffffff), fontSize: 15.0, fontFamily: 'Raleway'),
      ),
    );
  }

  void onDonePress() {
    // Back to the first tab
    this.goToTab(0);
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color(0xffffffff),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.refresh,
      color: Color(0xffffffff),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xffffffff),
    );
  }

  Color highlightTextColor = Color(0xff1F32FA);

  changeStyle(bool boolValue) {
    print(boolValue);
    setState(() {
      if (boolValue) {
        highlightTextColor = Color(0xffffffff);
      } else {
        highlightTextColor = Color(0xff1F32FA);
      }
    });
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      if (i < slides.length - 1) {
        tabs.add(
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Container(
              margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
              child: ListView(
                children: <Widget>[
                  GestureDetector(
                    child: Image.asset(
                      currentSlide.pathImage,
                      width: 400.0,
                      height: 400.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    child: Text(
                      currentSlide.title,
                      style: currentSlide.styleTitle,
                      textAlign: TextAlign.center,
                    ),
                    margin: EdgeInsets.only(top: 20.0),
                  ),
                  Container(
                    child: Text(
                      currentSlide.description,
                      style: currentSlide.styleDescription,
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    margin: EdgeInsets.only(top: 20.0),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        tabs.add(Container(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            margin: EdgeInsets.only(bottom: 60.0, top: 0.0),
            child: ListView(
              children: <Widget>[
                GestureDetector(
                  child: Image.asset(
                    currentSlide.pathImage,
                    width: 400.0,
                    height: 400.0,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  child: Text(
                    currentSlide.title,
                    style: currentSlide.styleTitle,
                    textAlign: TextAlign.center,
                  ),
                  margin: EdgeInsets.only(top: 20.0),
                ),
                Container(
                  child: Text(
                    currentSlide.description,
                    style: currentSlide.styleDescription,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  margin: EdgeInsets.only(top: 20.0),
                ),
                SizedBox(
                  width: 36.0,
                  child: RaisedButton(
                    color: Color(0xffffffff),
                    //textColor: styleOBJ ? Color(0xffffffff) : Color(0xff1F32FA),
                    padding: EdgeInsets.all(8.0),
                    splashColor: Color(0xff4B5AFB),
                    onHighlightChanged: (boolValue) => changeStyle(boolValue),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                    onPressed: () {
                      introViewed();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterFirstPage()),
                      );
                    },
                    child: Text(
                      "Get Started",
                      style:
                          TextStyle(fontSize: 20.0, color: highlightTextColor),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "Already have an account? Sign in",
                    style: TextStyle(fontSize: 15.0, color: Color(0xffffffff)),
                    textAlign: TextAlign.center,
                  ),
                  margin: EdgeInsets.only(top: 15.0),
                ),
              ],
            ),
          ),
        ));
      }
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Color(0x334B5AFB),
      highlightColorSkipBtn: Color(0xff4B5AFB),

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Color(0x334B5AFB),
      highlightColorDoneBtn: Color(0xff4B5AFB),

      // Dot indicator
      colorDot: Color(0xffffffff),
      sizeDot: 13.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
      listCustomTabs: this.renderListCustomTabs(),
      backgroundColorAllSlides: Color(0xff1F32FA),
      refFuncGoToTab: (refFunc) {
        this.goToTab = refFunc;
      },

      // Show or hide status bar
      shouldHideStatusBar: true,

      // On tab change completed
      onTabChangeCompleted: this.onTabChangeCompleted,
    );
  }
}
