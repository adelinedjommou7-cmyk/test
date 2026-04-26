import 'package:example/screens/niveau/widget/app_style.dart';
import 'package:example/screens/pagination/paginate.dart';
import 'package:flutter/material.dart';

class CustomPaginator<T> extends StatelessWidget {
  final Paginate<T> data;
  final Function(int page)? onPageChanged;
  final bool? disabled;

  bool get canGoNext => data.hasNext && !disabled!;

  bool get canGoPrev => data.hasPrev && !disabled!;

  bool _isCurrentPage(page) => page == data.page;

  const CustomPaginator(this.data,
      {Key? key, this.onPageChanged, this.disabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: kSecondaryColor,
            ),
            onPressed: canGoPrev ? _prev : null),
        ...List<Widget>.generate(
            data.totalPages, (page) => _numberButton(page + 1)),
        IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: kSecondaryColor,
            ),
            onPressed: canGoNext ? _next : null),
      ],
    );
  }

  _changePage(page) {
    if (page != data.page && onPageChanged != null) {
      onPageChanged!(page);
    }
  }

  _numberButton(pageNum) {
    return TextButton(
      onPressed: disabled! ? null : () => _changePage(pageNum),
      child: Text(
        "$pageNum",
        style: TextStyle(
            color: _isCurrentPage(pageNum)
                ? kPrimaryColor
                : disabled!
                    ? kPrimaryColor
                    : kSecondaryColor),
      ),
      style: TextButton.styleFrom(
          // shape: CircleBorder(side: BorderSide(width: 1, color: ThemeColor)),
          padding: const EdgeInsets.all(4),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: const Size(30, 30),
          backgroundColor:
              _isCurrentPage(pageNum) ? kSecondaryColor : Colors.transparent),
    );
  }

  _prev() {
    _changePage(data.page - 1);
  }

  _next() {
    _changePage(data.page + 1);
  }
}
