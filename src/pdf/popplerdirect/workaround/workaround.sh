#/bin/bash

cat > .test.h << EOF
#include <set>
#include <poppler/OutputDev.h>
#include <poppler/CairoOutputDev.h>
EOF


BASEDIR=$(dirname $0)
CONF=$BASEDIR/conf.h

echo '// autogenerated by workaround.sh' > ${CONF}

#always use internally packaged poppler
echo "workaround.sh: CairoOutputDev.h not found, use our version, which may not match your installed Poppler Version!"
echo '#ifdef HAVE_POPPLER_CAIRO_OUTPUT_DEV' >> ${CONF}
echo '# undef HAVE_POPPLER_CAIRO_OUTPUT_DEV' >> ${CONF}
echo '#endif' >> ${CONF}
cd src/pdf/popplerdirect/poppler-0.24.1/
autoreconf && automake --add-missing
./configure --enable-cms --enable-libopenjpeg --enable-libjpeg && make
cd ../../
ln -fs popplerdirect/poppler-0.24.1/poppler/.libs/libpoppler.a ./
ln -fs popplerdirect/poppler-0.24.1/glib/.libs/libpoppler-glib.a ./
