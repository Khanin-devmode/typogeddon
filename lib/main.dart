import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}

class SpaceShooterGame extends FlameGame with PanDetector, KeyboardEvents {
  late Player player;
  late Line line;
  late Word word1;

  int wordScore = 0;
  int playerScore = 0;

  final random = Random();

  void addWordScore() {
    wordScore++;
    print(wordScore);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final playerSprite = await loadSprite('player-sprite.png');

    player = Player()
      ..sprite = playerSprite
      ..position = Vector2(size.x / 2, size.y)
      ..width = 100
      ..height = 100
      ..anchor = Anchor.topCenter;
    add(player);

    line = Line()
      ..position = Vector2(size.x / 2, 100)
      ..width = size.x
      ..height = 1
      ..anchor = Anchor.center;
    add(line);

    word1 = Word(removeFn: addWordScore)
      ..text = 'Lorem'
      ..position = Vector2(size.x * random.nextDouble(), size.y);
    add(word1);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.game);
  }

  @override
  void update(double dt) {
    super.update(dt);

    player.move(Vector2(0, -2));
    word1.move(Vector2(0, -2));
    // print('${player.position.y} : ${line.position.y}');
    if (player.position.y == line.position.y) {
      remove(player);
    }
    if (word1.position.y == line.position.y) {
      remove(word1);
    }

    if (player.isRemoved) {
      player.position.x = size.x * random.nextDouble();
      player.position.y = size.y;
      add(player);
    }

    if (word1.isRemoved) {
      word1.position.x = size.x * random.nextDouble();
      word1.position.y = size.y;
      add(word1);
    }
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    if (keysPressed.isNotEmpty && isKeyDown) {
      // if (keysPressed.contains(LogicalKeyboardKey.altLeft) ||
      //     keysPressed.contains(LogicalKeyboardKey.altRight)) {
      //   this.shootHarder();
      // } else {
      //   this.shoot();
      // }
      print(keysPressed.single.keyLabel);

      // return KeyEventResult.;
    }
    return KeyEventResult.ignored;
  }
}

class Line extends PositionComponent {
  static final _paint = Paint()..color = Colors.white;

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }

  // void move(Vector2 delta) {
  //   position.add(delta);
  // }
}

class Player extends SpriteComponent with HasGameRef<SpaceShooterGame> {
  void move(Vector2 delta) {
    position.add(delta);
  }
}

class Word extends TextComponent {
  Word({required this.removeFn});

  final Function removeFn;

  void move(Vector2 delta) {
    position.add(delta);
  }

  @override
  void onRemove() {
    // TODO: implement onRemove
    removeFn();
    super.onRemove();
  }
}
