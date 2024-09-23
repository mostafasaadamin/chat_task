import 'package:chat/extentions/time_extension.dart';
import 'package:chat/repository/remote/auth_repository.dart';
import 'package:chat/screens/users/bloc/users_list_event.dart';
import 'package:chat/screens/users/bloc/users_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bloc/users_list_bloc.dart';

class UsersListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
      ),
      body: BlocProvider(
        create: (context) => UsersBloc(authRepository:AuthRepository()),
        child: _UsersList(),
      ),
    );
  }
}

class _UsersList extends StatefulWidget {
  @override
  State<_UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<_UsersList> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<UsersBloc>().add(LoadUsersEvent());
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UsersLoaded) {
          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return ListTile(
                leading: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        imageUrl: user.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color:user.isOnline? Colors.green:Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user.isOnline ? 'Online' : user.lastOnline.toLastOnlineMessage()),
              );
            },
          );
        } else if (state is UsersError) {
          return Center(child: Text('Failed to load users: ${state.message}'));
        } else {
          return Center(child: Text('Unknown state'));
        }
      },
    );
  }
}
