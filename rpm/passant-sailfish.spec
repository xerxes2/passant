Name: passant
Version: 
Release: 1
Summary: Passant - chess game

#Group:
License: GPLv3
URL: https://github.com/xerxes2/panucci
Source: passant-%{version}.tar.gz
#BuildRoot: %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

BuildRequires: python
Requires: pyqt, qt5-qtsvg-plugin-imageformat-svg

%description
A chess game written in python.

%prep
%setup -q

%build
python setup.py build

%install
rm -rf $RPM_BUILD_ROOT
python setup.py install --no-compile -O2 --root=$RPM_BUILD_ROOT
cp icons/passant-86x86.png $RPM_BUILD_ROOT/usr/share/pixmaps/passant.png
# Remove unneeded stuff
rm $RPM_BUILD_ROOT/usr/share/pixmaps/passant.svg
rm -r $RPM_BUILD_ROOT/usr/share/passant/qml
rm -r $RPM_BUILD_ROOT/usr/lib/python2.7/site-packages/passant/qmlui

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%{_bindir}/*
%{_libdir}/*
%{_datadir}/*

%doc

%changelog
