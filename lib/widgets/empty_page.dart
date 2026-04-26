import 'package:example/screens/home/presentation/home.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CustomEmptyPage extends StatelessWidget {
  const CustomEmptyPage({
    this.title = 'Aucune correspondance pour cette demande n\'a été trouvé ',
    this.url = 'assets/gifs/GIF 6.gif',
  });

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            url,
            // controller: _controller,
            // height: MediaQuery.of(context).size.height,
            width: 500,
            height: 500,
            fit: BoxFit.fill,
          ),
          Text(
            title,
          ),
        ],
      ),
    );
  }
}
