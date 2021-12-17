import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:siento11/Direccion/carpinteria.dart';
import 'package:siento11/Direccion/gerencia_home.dart';
import 'package:siento11/Direccion/historial.dart';

class bottom_nav extends StatefulWidget {
  const bottom_nav({Key? key}) : super(key: key);

  @override
  bottom_navState createState() => bottom_navState();
}

class bottom_navState extends State<bottom_nav> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    carpinteria(),
    gerencia_home(),
    historial(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  Widget notificacionesPedidoAdmin (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Notificaciones').doc("Pedidos"+correo.toString()).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            var notifaciones = data['notificacion'];

            return
              notifaciones == "0"?
              Icon(Icons.notifications_none,)
                  :
              Badge(
                position: BadgePosition(left: 20, bottom: 20),
                badgeColor: Colors.red[700],
                badgeContent: Text(notifaciones, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                child: Icon(Icons.notifications_active,),
              );
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xff6DA08E),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: notificacionesPedidoAdmin(context),
           label: "Pedidos",
         ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_photo_alternate_outlined,),
            label: "Catalogo",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.monetization_on_outlined,
            ),
            label: 'Ventas',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        selectedFontSize: 14.0,
        unselectedFontSize: 13.0,
      ),
    );
  }
}