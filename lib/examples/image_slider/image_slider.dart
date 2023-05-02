import 'package:flutter/material.dart';
import 'package:simple_examples/examples/image_slider/utils.dart';

import 'data.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final double _padding = 8;

  int? _indexSelected;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  double get cardWidth {
    if (MediaQuery.of(context).size.width <= mobile) {
      return (MediaQuery.of(context).size.width - (_padding * 2)) / 2.25;
    }
    if (MediaQuery.of(context).size.width <= tablet) {
      return (MediaQuery.of(context).size.width - (_padding * 2)) / 3.25;
    }
    if (MediaQuery.of(context).size.width <= desktop) {
      return (MediaQuery.of(context).size.width - (_padding * 2)) / 4.25;
    }
    return (MediaQuery.of(context).size.width - (_padding * 2)) / 5.25;
  }

  double get cardMaxWidth => cardWidth * 1.5;

  void _onTap(index) {
    if (index == _indexSelected) {
      setState(() {
        _indexSelected = null;
      });
      return;
    }
    setState(() {
      _indexSelected = index;
    });
  }

  void _onTapDown(TapDownDetails details, int index) {
    if (_indexSelected == index) return;
    final globalPositionInitCard =
        details.globalPosition.dx - details.localPosition.dx;
    if (globalPositionInitCard < 0) {
      _scrollController.animateTo(((cardWidth + _padding) * index),
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      return;
    }
    final finalScrollPosition = ((cardWidth + _padding) * index) -
        (MediaQuery.of(context).size.width - cardMaxWidth - _padding * 2)
            .clamp(0, _scrollController.position.maxScrollExtent);
    if (globalPositionInitCard + cardMaxWidth >
        (MediaQuery.of(context).size.width - _padding * 2)) {
      _scrollController.animateTo(finalScrollPosition,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Slider")),
      body: Column(
        children: [
          SizedBox(
            height: cardWidth,
            child: LayoutBuilder(
              builder: (_, constraint) {
                return ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.all(_padding),
                  itemCount: data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onTap(index),
                      onTapDown: (details) => _onTapDown(details, index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width:
                            index == _indexSelected ? cardMaxWidth : cardWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(data[index].image),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: index == _indexSelected
                              ? [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withOpacity(0.3),
                                    blurRadius: 1,
                                    offset: const Offset(5, 5),
                                  )
                                ]
                              : null,
                        ),
                        child: ContentCard(
                          indexSelected: _indexSelected,
                          cardWidth: cardWidth,
                          index: index,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(width: 8);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Dots(
            itemsLength: data.length,
            scrollController: _scrollController,
            padding: _padding,
            cardWidth: cardWidth,
          ),
        ],
      ),
    );
  }
}

class ContentCard extends StatefulWidget {
  const ContentCard({
    super.key,
    required this.cardWidth,
    required this.index,
    required this.indexSelected,
  });

  final int index;
  final int? indexSelected;
  final double cardWidth;

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  final GlobalKey _containerKey = GlobalKey();
  Size? _containerSize;
  final _duration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? containerRenderBox =
          _containerKey.currentContext?.findRenderObject() as RenderBox?;
      if (containerRenderBox != null) {
        setState(() {
          _containerSize = containerRenderBox.size;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: _duration,
            bottom: widget.index == widget.indexSelected
                ? _containerSize?.height ?? 0
                : 0,
            left: 0,
            right: 0,
            child: Text(
              data[widget.index].title,
              style: Theme.of(context).textTheme.titleLarge,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: _duration,
              opacity: widget.index == widget.indexSelected ? 1 : 0,
              child: Text(
                key: _containerKey,
                data[widget.index].description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Dots extends StatefulWidget {
  const Dots(
      {Key? key,
      required this.scrollController,
      required this.cardWidth,
      required this.padding,
      required this.itemsLength})
      : super(key: key);

  final int itemsLength;
  final ScrollController scrollController;
  final double cardWidth;
  final double padding;

  @override
  State<Dots> createState() => _DotsState();
}

class _DotsState extends State<Dots> {
  int _selectedIndex = 0;

  int _dotsCount = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_listener);
    Future.microtask(() {
      _dotsCount = (widget.itemsLength / cardsPerSection).round();
      setState(() {});
    });
  }

  void _listener() {
    final maxSizePerSection =
        (widget.cardWidth + widget.padding) * cardsPerSection;
    final currentScrollOffset = widget.scrollController.offset;
    final currentSection = currentScrollOffset / maxSizePerSection;
    if (_selectedIndex != currentSection.round()) {
      _selectedIndex = currentSection.round();
      setState(() {});
      return;
    }
  }

  double get cardsPerSection {
    if (MediaQuery.of(context).size.width <= mobile) {
      return 2;
    }
    if (MediaQuery.of(context).size.width <= tablet) {
      return 3;
    }
    if (MediaQuery.of(context).size.width <= desktop) {
      return 4;
    }
    return 5;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dotsCount = (widget.itemsLength / cardsPerSection).truncate();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollController.removeListener(_listener);
  }

  void _onTap(int index) {
    final cardPositionToMove =
        (widget.cardWidth + widget.padding) * (index * cardsPerSection);
    widget.scrollController.animateTo(
      cardPositionToMove.clamp(
          0, widget.scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.scrollController.hasClients) return const Offstage();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_dotsCount, (index) {
        return Dot(
          onTap: () => _onTap(index),
          backgroundColor: _selectedIndex == index
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.background,
        );
      }),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({
    Key? key,
    this.backgroundColor,
    this.onTap,
  }) : super(key: key);
  final Color? backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey,
          shape: BoxShape.circle,
        ),
        width: 10,
        height: 10,
      ),
    );
  }
}
