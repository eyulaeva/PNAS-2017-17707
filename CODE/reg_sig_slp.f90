       program netcdf_convert
       use netcdf
       implicit none
!       include 'netcdf.inc'
      integer i,j,k,ncid,latid,fieldid,ierr,dims(3),dim,start(3), &
      count(3), latvid, lonid, lonvid, level, depid, depvid,rcode
      integer recl, did,dvid, timid,timvid,iyr,ii
       integer f1,f2,f3, coord_ids(3), v_cid,iostat
       integer vars_cid(22),ii1
       character*20 vars_name(22)
      integer kmt,i1,id,kmt1,k1
      integer imt,jmt,imo,it,ncstat,ncid1,varid
      integer numcol,numline
!      real, parameter :: spval = 9.96921e+36
      integer, parameter :: spval = 0
      parameter(imt=144,jmt=73,kmt=444)
      real u10 (imt,jmt,kmt),u10_1(imt,jmt,36),xx(36)
       real u10_clm (imt,jmt,12),u10_1A(imt,jmt,36)
      real ext(37),ucor(imt,jmt,24),c1,c2,c3,uc(imt,jmt,12),a1
       real uc2(imt,jmt,24) 
      character*80 attr_name, attr_valc, filename, dim_name
      character*80 infile,infile2
      character*80 var_name
      character*200 str1
      character*4 ch4
      character*2 mon(12)
      character*1 ch1
      character*2 ch2
      data mon /"01","02","03","04","05","06","07","08",&
         "09","10","11","12"/

           open(1, file='ice_area_Sep_1980_2016_anom_P1.d')
           read(1,*) ext
!           do i=1,34
!           read(1,*) ext(i)
!           end do
             close(1)
!==============================
!            where (dns.gt.1.0) dns=1.
!            print*, 'max,min dns', maxval(dns),minval(dns)
        infile='MSLP_clm.nc'
              iostat = nf90_open&
      (infile,nf90_nowrite,ncid1)
                   print*, 'iostat after open 1', iostat
          iostat = nf90_INQ_VARID(ncid1, 'pressure', varid)
                   print*, 'iostat after inq id1', iostat
              iostat =  nf90_get_var(ncid1,varid,uc,start=(/1,1,1/),&
                        count = (/imt,jmt,12/))
                iostat= nf90_close(ncid1)
           uc2(:,:,1:12)= uc(:,:,1:12)
           uc2(:,:,13:24)= uc(:,:,1:12)
!!!
            infile='MSLP_1980_2017.nc'
              iostat = nf90_open&
      (infile,nf90_nowrite,ncid1)
                   print*, 'iostat after open 1', iostat
          iostat = nf90_INQ_VARID(ncid1, 'pressure', varid)
                   print*, 'iostat after inq id2', iostat
              iostat =  nf90_get_var(ncid1,varid,u10,start=(/1,1,1/),&
                        count = (/imt,jmt,kmt/))
                iostat= nf90_close(ncid1)

          infile='MSLP_reg_sig_SepIce_P1P2.nc'
            iostat = nf90_open&
      (infile,nf90_write,ncid1)
                   print*, 'iostat after open 1', iostat
          iostat = nf90_INQ_VARID(ncid1, 'pressure', varid)
                   print*, 'iostat after inq id3', iostat
!                   print*, 'max,min', maxval(u10),minval(u10)
                          do imo=1,12
                          do iyr=1,37
!          Up to a year lag
          u10_1(:,:,iyr)=u10(:,:,(iyr-1)*12+9+imo-1)-uc2(:,:,9+imo-1)
                          end do
                  print *, 'imo=', imo
                    do i=1,imt
                    do j=1,jmt
                         xx(:)= u10_1(i,j,:)
                         c1=0.
                         c2=0.
                         c3=0.
                         do  iyr=1,19
                      c1=c1+xx(iyr)*ext(iyr)
                      c2=c2+xx(iyr)*xx(iyr)
                      c3=c3+ext(iyr)*ext(iyr)
                       end do
!                       ucor(i,j,imo)=c1/sqrt(c3)
                       a1=c1/c3
                       ucor(i,j,imo)=a1*sqrt(c3)/sqrt(abs(c2-a1*c1))*sqrt(17.)
!                print*, 'max,min',maxval(ucor),minval(ucor)
                         c1=0.
                         c2=0.
                         c3=0.
                         do  iyr=1,17
                      c1=c1+xx(iyr+19)*ext(iyr+19)
                      c2=c2+xx(iyr+19)*xx(iyr+19)
                      c3=c3+ext(iyr+19)*ext(iyr+19)
                       end do
                       a1=c1/c3
                       ucor(i,j,imo+12)=a1*sqrt(c3)/sqrt(abs(c2-a1*c1))*sqrt(15.)                      
!                       ucor(i,j,imo+12)=c1/sqrt(c3)
                        end do
                        end do
                   print*, maxval(ucor(:,:,imo)),minval(ucor(:,:,imo))
                   print*, maxval(ucor(:,:,imo+12)),minval(ucor(:,:,imo+12))
                        end do
             iostat = nf90_put_var(ncid1,varid,ucor,start=(/1,1,1/),&
                  count = (/ imt,jmt,24/))

         iostat= nf90_close(ncid1)
      stop
      end
