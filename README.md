# FlyRoute [](https://pub.dev/packages/flyRoute)

A Stack that shows a single child from a list of children. Similar in concept to IndexedStack, but it uses Strings as keys and has a number of extra features like child nesting, custom animations and path arguments.

## 🔨 Installation [](https://pub.dev/packages/flyRoute#-installation)

```yaml
dependencies:
  flyRoute: ^1.2.1
```

### ⚙ Import [](https://pub.dev/packages/flyRoute#-import)

```dart
import 'package:flyRoute/flyRoute.dart';
```

## 🕹️ Usage [](https://pub.dev/packages/flyRoute#-usage)

To configure a `flyRoute` provide it with a routing table by settings the `.routes` value. Declare the paths that you want to support and their corresponding views:

```dart
String currentPath = "page1";
...
return flyRoute(
  path: currentPath,
  unknownPathBuilder: (_) => Custom404Page(),
  routes: {
      ["page1"]: (_) => Page1(),
      ["page2"]: (_) => Page2(),
    });
  }
```

A route can match multiple path values. For example this will match when the `path` value is `/` or `/home`:

```dart
   ["home", "/"]: (_) => Home(),
```

### Relative paths [](https://pub.dev/packages/flyRoute#relative-paths)

`flyRoute` also allows you to easily declare relative paths by wrapping one `flyRoute` within another.

For example, you could define a simple nested structure like:

```dart
return flyRoute(
  path: path,
  routes: {
    ["home"]: (_) => HomePage(),
    ["news"]: (_) => NewsPage(),
    ["settings/"]: (_) => PflyRoute
          routes: {
            ["profile", ""]: (_) => ProfilePage(),
            ["notifications"]: (_) => NotificationsPage(),
          },
        ),
  },
);
```

Which results in the following potential routes:

- /home
- /news
- /settings/profile
- /settings/notifications

### Scaffold Builder / Nesting [](https://pub.dev/packages/flyRoute#scaffold-builder--nesting)

To support the common use case of shared navigation or app chrome there is `scaffoldBuilder` which lets you wrap any Widget around the current `flyRoute` child.

This means you can create a basic tab-scaffold like this:

```dart
    return flyRoute(
      path: currentPath,
      scaffoldBuilder: (_, child) =>
         TabScaffold(
           child: child,
           onTabPressed: (value){
             setState(() => _currentPath = value)
         }})),
      routes: {
        ["/home"]: (_) => HomePage(),
        ["/settings"]: (_) => SettingsPage()
        ["/explore"]: (_) => ExplorePage(),
      },
    );
  }
```

#### Exact vs Partial Matches

Each route can be configured to accept exact or partial matches. For convenience, `flyRoute` makes some assumptions based on the presence of a trailing slash in your paths:

**Routes with no trailing slash in the are assumed to be an exact match:**

```dart
  ["details"]: (_) => Details(), // matches only `/details`
```

**Routes with trailing slash are assumed be a partial match:**

```dart
  ["details/"]: (_) => Details(), // matches any of `/details/`, `/details/12`, `/details/id=12&foo=99` etc
```

If multiple route paths are defined, only the first entry in the path list is considered for this default behavior:

```css
["details", "/"]: (_) => Details(), // matches only `/details` or '/' exactly
```

You can disable this default behavior by wrapping your view in a `RouteConfig` widget (shown below).

### Using RouteConfig to set optional params [](https://pub.dev/packages/flyRoute#using-routeconfig-to-set-optional-params)

To configure additional options on a route, you can wrap it in a `RouteConfig` widget:

```dart
  ["/admin"]: (_) => RouteConfig(
    maintainState: false, // Tell this route not to maintain state
    exactMatch: false,  // Tell this route it does not need an exact match (it can be matched as a prefix)
    onBeforeEnter: (newRoute) => return isLoggedIn == true, // Return false here to prevent the path from changing
    child: AdminPage())
```

### Arguments [](https://pub.dev/packages/flyRoute#arguments)

You can pass arguments to your routes using either **path based** or **query string** args.

To use path based args you embed the name of the params in the route itself as: `"details/:foo/:bar"`, then extract them from `stack.args` with the same names:

```dart
flyRoute(
  path: "details/10/20",
  routes: {
    ["details/:foo/:bar"]: (stack) => DetailsPage(foo: stack.args["foo"], bar: stack.args["bar"]),
  }
)
```

With query string style, the parsing is the same, but the names are embedded in the path rather than the route:

```dart
flyRoute(
  path: "/details?foo=10&bar=20",
  routes: {
    ["details/"]: (stack) => DetailsPage(foo: stack.args["foo"], bar: stack.args["bar"]),
  }
)
```

### Full Example [](https://pub.dev/packages/flyRoute#full-example)

There are several other features not mentioned here, including custom route transitions, support for unknown paths (404) and a `caseInsensitive` setting.

For a full API tour, you can view the following code sample:

```dart
return flyRoute(
    // Path is the source of truth for each stack, usually this is shared by all child stacks
    path: currentPath,
    // Optional: Provide custom widget for unknown paths
    unknownPathBuilder: (_) => Center(child: Text("Custom 404 Page")),
    // Optional: Provide custom animationIn (default is no animation)
    transitionBuilder: (_, stack, anim1) => FadeTransition(opacity: anim1, child: stack),
    // Optional: Provide duration for animationIn
    transitionDuration: Duration(milliseconds: 200),
    // By default pages are case insensitive, like a web server. But you can turn this off
    caseSensitive: true,
    // Define all matching routes for this stack
    routes: {
      ["home", "/"]: (_) => HomePage(),
      // Example of a route guard, you can return false to block the change
      ["admin"]: (_) => RouteConfig(
            child: AdminPage(),
            onBeforeEnter: (_){
                if (isLoggedIn) return true;
                scheduleMicrotask(() => setState(() => currentPath = "home"));
                return false;
            },
          ),
      // Adding a "/" at the end of any path indicates it can match as a prefix but you can override this
      ["settings/"]: (_) => PflyRoute
            // Wrap all settings routes in a shared scaffold
            scaffoldBuilder: (_, stack) => Column(children: [
              Padding(padding: EdgeInsets.all(20), child: Text("Shared Settings App Bar")), // Settings Header
              Expanded(child: stack),
            ]),
            // Define child routes for settings section
            routes: {
              // By adding a "" alias, the first route will match both `/settings/alerts` and `/settings/`
              ["alerts", ""]: (_) => AlertsPage(),
              ["profile"]: (_) => ProfilePage(),
              ["billing/:foo/:bar"]: (stack) => BillingPage(id: "${stack.args["foo"]}_${stack.args["bar"]}"),
            },
          ),
    },
  );
```

## 🐞 Bugs/Requests [](https://pub.dev/packages/flyRoute#-bugsrequests)

If you encounter any problems please open an issue. If you feel the library is missing a feature, please raise a ticket on Github and we'll look into it. Pull request are welcome.

## 📃 License [](https://pub.dev/packages/flyRoute#-license)

MIT License