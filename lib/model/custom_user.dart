
import 'package:equatable/equatable.dart';

class CustomUser extends Equatable {
  String? idUser;
  String? fullName;
  String? email;
  String? phone;
  String? dateOfBirth;
  String? gender;
  String? image;
  String? address;
  List<String>? hobby;

  CustomUser(
      {this.idUser,
      this.fullName,
      this.email,
      this.phone,
      this.dateOfBirth,
      this.gender,
      this.image,
      this.address,
      this.hobby});

  CustomUser.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    fullName = json['fullName'];
    email = json['email'];
    phone = json['phone'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'];
    image = json['image'];
    address = json['address'];
    hobby = json['hobby'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUser'] = this.idUser;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['dateOfBirth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['image'] = this.image;
    data['address'] = this.address;
    data['hobby'] = this.hobby;
    return data;
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [fullName,email,phone,dateOfBirth,gender,image,hobby,idUser,address];
}