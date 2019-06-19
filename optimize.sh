#!/bin/sh
#
#
#

repertoire=$1

if [ -n $repertoire ] ; then
	dir=/home/ubuntu/convert
	data=$dir/data
	dest=$dir/dest

	export dir data dest

	chmod +x *.sh

	date=`date +%Y%m%d`

	echo "*** TRAVAIL DANS : ***";
	echo $repertoire
	echo "**********************";

	rm -rf $dest/$repertoire
	mkdir $dest/$repertoire &> /dev/null

	function traite_image
	{
	for f in `ls $1/`; do
		dest_dir=`echo $1 | perl -pe 's:\/convert\/data\/:\/convert\/dest\/:;'`
		
		if [ -d $dest_dir ] ; then
			if [ -d $1/$f ] ; then
				echo "Répertoire $f à partir de $1"
				
				mkdir $dest_dir/$f &> /dev/null
				
				traite_image "$1/$f"
			elif [ -f $1/$f ] ; then
				extension=${f#*.}
				
				echo "Conversion de $f dans $dest_dir"
				
				if [ $extension = "jpg" ] ; then
					convert $1/$f -sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG -colorspace sRGB $dest_dir/$f
				elif [ $extension = "png" ] ; then
					convert $1/$f -strip $dest_dir/$f
				elif [ $extension = "gif" ] ; then
					convert $1/$f -strip $dest_dir/$f
				fi
			fi
		fi
	done
	}
	
	traite_image "$data/$repertoire"
else
	echo "Veuillez renseigner le nom du répertoire";
fi
