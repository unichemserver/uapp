class MenuModel {
  String message;
  List<MenuData> menus;

  MenuModel({required this.message, required this.menus});

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    var menuList = json['menus'] as List;
    List<MenuData> menusList = menuList.map((e) => MenuData.fromJson(e)).toList();

    return MenuModel(
      message: json['message'],
      menus: menusList,
    );
  }
}

class MenuData {
  String idMenu;
  String namaMenu;
  String iconMenu;
  String urlMenu;
  List<SubMenu> submenu;

  MenuData({
    required this.idMenu,
    required this.namaMenu,
    required this.iconMenu,
    required this.urlMenu,
    required this.submenu,
  });

  factory MenuData.fromJson(Map<String, dynamic> json) {
    var submenuList = json['submenu'] as List;
    List<SubMenu> submenus = submenuList.map((e) => SubMenu.fromJson(e)).toList();

    return MenuData(
      idMenu: json['id_menu'].toString(),
      namaMenu: json['nama_menu'],
      iconMenu: json['icon_menu'],
      urlMenu: json['url_menu'],
      submenu: submenus,
    );
  }
}

class SubMenu {
  String idMenu;
  String namaMenu;
  String iconMenu;
  String urlMenu;
  List<SubSubMenu> subsubmenu;

  SubMenu({
    required this.idMenu,
    required this.namaMenu,
    required this.iconMenu,
    required this.urlMenu,
    required this.subsubmenu,
  });

  factory SubMenu.fromJson(Map<String, dynamic> json) {
    var subsubmenuList = json['subsubmenu'] as List;
    List<SubSubMenu> subsubmenus = subsubmenuList.map((e) => SubSubMenu.fromJson(e)).toList();

    return SubMenu(
      idMenu: json['id_menu'].toString(),
      namaMenu: json['nama_menu'],
      iconMenu: json['icon_menu'],
      urlMenu: json['url_menu'],
      subsubmenu: subsubmenus,
    );
  }
}

class SubSubMenu {
  String idMenu;
  String namaMenu;
  String iconMenu;
  String urlMenu;

  SubSubMenu({
    required this.idMenu,
    required this.namaMenu,
    required this.iconMenu,
    required this.urlMenu,
  });

  factory SubSubMenu.fromJson(Map<String, dynamic> json) {
    return SubSubMenu(
      idMenu: json['id_menu'].toString(),
      namaMenu: json['nama_menu'],
      iconMenu: json['icon_menu'],
      urlMenu: json['url_menu'],
    );
  }
}
