CREATE OR REPLACE package body WEBSYS.myvideo as

 -- Test if extension of filename is a video one
 function video_api( v_filename varchar2 )
  return char
 as

  ext	varchar2(100);

 begin

  ext := upper(glbx.extract_fname( v_filename, 'SUFFIX' ));
  if ext in ('MPEG','MPG','MPE','AVI','ASF','DVX','DIVX','MPV2','MP2V','QT','MOV','MOVIE','VDO','RA','RM','RAM','MP4','3GP')
   then
    return( 'T' ); -- Note: Cannot return a boolean due to the limitations of dynamic SQL and booleans
   else
    return( 'F' );
  end if;

 end video_api;

 -- Modify Meta Tag
 procedure video_api(v_umo integer, attrib_id integer, data_value varchar2, acid integer, posid integer, action varchar2 )
 as
  tokens	ump.myarray;
  retstmt	varchar2(100);

 begin
  if action in ('UPDATE','DELETE')
   then
    delete from umo_index where umo_id = v_umo and attribute_id = attrib_id and aid = acid and position_id = posid;
  end if;
  if action = 'DELETE' then return; end if;
  retstmt := ump.extract_tokens( data_value, 1, FALSE, tokens );
  if not tokens.exists( 1 ) then return; end if; -- Nothing extracted
  for j in tokens.first..tokens.last loop
   insert into umo_index(umo_id, aid, attribute_id, word_original,word_upper,word_soundex,ordering,position_id) values
    (v_umo, acid, attrib_id, tokens(j), upper(tokens(j)), soundex_api(tokens(j),attrib_id), j, posid);
  end loop;
 end video_api;

 -- Mass Modification
 procedure video_api(v_umo integer, new_acid integer, old_acid integer, action varchar2 )
 as
 begin
  null;
 end video_api;

 -- This API is called whilst loading the Video
 -- How Loaded is BATCH or BROWSER
 -- ACTION is INSERT, UPDATE, DELETE

 -- Oracle Supported Video Formats: ASF, AVI, MOOV, MP4, MPEG, RMFF

 procedure video_api(v_umo integer, schemaname varchar2, howloaded varchar2, action varchar2 )
 as

  cursor c1(v_umo integer) is select * from umo where umo_id = v_umo;
  c1rec  c1%ROWTYPE;

  ext	varchar2(100);
  mtype	varchar2(100);

 begin
  -- Step 1: Extract the suffix and set the mime type
  open c1(v_umo);
  fetch c1 into c1rec;
  close c1;
  ext := upper(glbx.extract_fname( c1rec.video_original_loc, 'SUFFIX' ));
  if ext in ('MPEG','MPG','MPE') then mtype := 'video/mpeg';
  elsif ext in ('MPV2','MP2V') then mtype := 'video/mpeg2';
  elsif ext in ('QT','MOV') then mtype := 'video/quicktime';
  elsif ext in ('AVI','ASF','DVX','DIVX') then mtype := 'video/x-msvideo';
  elsif ext in ('MOVIE') then mtype :=   'video/x-sgi-movie';
  elsif ext in ('MP4') then mtype := 'application/mpeg4';
  elsif ext in ('3GP') then mtype := 'application/3gp';
  elsif ext in ('VDO') then mtype := 'video/vdo';
  elsif ext in ('VDO') then mtype := 'video/vdo';
  elsif ext in ('RA') then mtype := 'audio/x-pn-realaudio';
  elsif ext in ('RAM') then mtype := 'audio/x-pn-realaudio';
  elsif ext in ('RM') then mtype := 'audio/x-pn-realaudio';
  end if;

  if mtype is not null
   then
    update umo um
     set
      um.video_original.mimetype = mtype,
      um.extras.film_name = glbx.extract_fname( c1rec.video_original_loc, 'NO_EXTENSION' ),
      um.extras.photo_name = glbx.extract_fname( c1rec.video_original_loc, 'NO_EXTENSION' )
    where
     umo_id = v_umo;
  commit;
  end if;

 exception
  when others then
   null;
 end video_api;

 -- This Object Displays the UMO Thumbnail Representation
 procedure video_api(surl in varchar2, umo_rec in integer, theme_data in CHAR, left_api_parm in VARCHAR2, current_page_number in integer, display_detail in varchar2, footer_api in varchar2, ltype in varchar2, acid in integer )
 as

  cursor c1(v_umo integer) is select aid,um.video_original.mimetype mtype,um.photo_thumbnail.contentlength cl, version, um.photo_thumbnail.width width, um.photo_thumbnail.height height from umo um where umo_id = v_umo;
  cursor c2(acid integer) is select * from theme where theme_name in (select theme_name from customer_account where aid = acid );

  c1rec	 c1%ROWTYPE;

  url	 varchar2(1000);
  trg	 varchar2(100);
  alt	 varchar2(100);
  pfx	 THEME%ROWTYPE;
  xltype varchar2(100);

 begin
  htp.p( '<CENTER>' );
  open c1(umo_rec);
  fetch c1 into c1rec;
  close c1;
  open c2(c1rec.aid);
  fetch c2 into pfx;
  close c2;

  xltype := ltype;
  if xltype = 'PHOTOGRAPHERX' then xltype := 'PHOTOGRAPHER'; end if;

  if ltype = 'PHOTOGRAPHER'
   then
    trg := NULL;
    alt := 'Click to Edit Video Details';
    if display_detail = 'S'
     then
      url := footer_api || '?surl=' || glbx.rndsurl(surl) || '&left_api_parm=[' || umo_rec || ']' || replace(left_api_parm,' ','+') || '&start_from=' || current_page_number || '&display_detail=' || display_detail || '&acid=' || acid;
     else
      url := 'phg.phg_modify?surl=' || glbx.rndsurl(surl) || '&phgid=' || umo_rec || '&acid=' || acid || '&msg=&footer_api=' || replace(footer_api,' ','+') || '&left_api_parm=' || replace(left_api_parm,' ','+') || '&current_page_number=' || current_page_number || '&display_detail=' || display_detail;
    end if;

   else

    -- If streaming video need to call the Real Player API else just dump it out
    alt := 'Click to Play Video';
    if c1rec.mtype = 'audio/x-pn-realaudio'
     then
      url := 'rtsp://' || substr( glbx.extract_master_parameter('PICTION_HOME_PAGE'),8) || ':554/dbproc/' || umo_rec;
      trg := NULL;
     else
      url := 'myvideo.embed_tag?surl=' || surl || '&v_umo=' || umo_rec || '&acid=' || acid;
      trg := 'Play Video' ;
    end if;

  end if;

  if nvl(c1rec.cl,0) = 0
   then
    htp.anchor2( url, htf.img( DECS.IMAGE_LOCATION || 'admin/big_acct.gif',cattributes=>'border=0',calt=>'Click to Play Video' ), ctarget=>trg);
   else
    glbx.image_matte(pfx=>pfx,wd=>c1rec.width,hg=>c1rec.height,
           trg=>url,
           trgdisp=>'<IMG BORDER=0 WIDTH=' || c1rec.width || ' HEIGHT=' || c1rec.height || ' SRC="' ||
           'ump.retrieve_uma?surl=' || glbx.truncsurl(surl) || '&parm1=UMO_ID&parm2=' || umo_rec || '&parm1=OVERRIDE_DISPLAY&parm2=PHOTO&parm1=DISPLAY_TYPE&parm2=RAW&parm1=DISPLAY_WHAT&parm2=THUMBNAIL' || '&parm1=LOGIN_TYPE&parm2=' || xltype || '&parm1=VERSION&parm2=' || c1rec.version || '&parm1=AID&parm2=' || acid ||
           '" ALT="' || alt || '" ' || 'STYLE="display:block;">',
           ctarget=>trg );
  end if;

  htp.nl;
  htp.p( '</CENTER>' );

 end video_api;

 procedure video_api(v_umo integer, ltype varchar2, left_api varchar2,left_api_parm varchar2, footer_api varchar2)
 as
 begin
  null;
 end video_api;

 -- Used on Mass load to perform specific options and processing
 procedure video_api(v_umo integer, vload_id integer, action varchar2)
 as
 begin
  null;
 end video_api;

 procedure embed_tag(surl in varchar2, v_umo in integer, acid in integer )
 as

 begin
  play_video( surl, v_umo, acid );
 end embed_tag;

 procedure play_video(surl in varchar2, v_umo in integer, acid in integer )
 as

   c1rec		customer_account%ROWTYPE;
   ump_param_types 	UMP.PARAMETERS;
   ump_param_values 	UMP.PARAMETERS;
   ltype		varchar2(100);
   stype		integer;
   owner_id		integer;
   profid		integer;
   sts			varchar2(100);

 begin

 glbx.cookie_id( surl, stype, ltype, owner_id, sts, 'S', progcalled=>'MYVIDEO.PLAY_VIDEO' );
 if sts is not null
  then
   glbx.redisplay_login_page( sts, TRUE );
   return;
 end if;

 c1rec := glbx.get_cusrec( owner_id, ltype, acid, profid );
 --
 -- Set up the param arrays used in ump.retrieve
 --
 ump_param_types(1) := 'UMO_ID';
 ump_param_values(1) := v_umo;
 ump_param_types(2) := 'DISPLAY_TYPE';
 ump_param_values(2) := 'RAW';
 ump_param_types(3) := 'DISPLAY_WHAT';
 ump_param_values(3) := 'MASTER';
 ump_param_types(4) := 'LOGIN_TYPE';
 ump_param_values(4) := ltype;
 ump_param_types(5) := 'AID';
 ump_param_values(5) := c1rec.aid;


 ump.retrieve_uma(surl=> glbx.truncsurl(surl)
               ,parm1=> ump_param_types
               ,parm2=> ump_param_values);

 end play_video;
/*
-- Configuration File contains call to retrieve blob
-- \real\realserver\rmserver.cfg
<List Name="Oracle DB system procedure">
         <Var ShortName="pn-oracle"/>
         <Var MountPoint="/dbproc/"/>
         <Var Database="PRD1"/>
         <Var Username="WEBSYS"/>
         <Var Password="WEBSYS"/>
         <Var SQL="begin myvideo.GetVideo(:DATA,:MIMETYPE,$url1$); end;"/>
         <Var Authentication="False"/>
     </List>
*/
 procedure getvideo( data out blob, mimetype out varchar2, id in number )
 as

  cursor c1 is select * from umo um where umo_id = id;
  c1rec  c1%ROWTYPE;

 begin
  -- Need a call to protect this...
  open c1;
  fetch c1 into c1rec;
  close c1;
  data := c1rec.video_original.source.localdata;
  mimetype := c1rec.video_original.mimetype;

 end getvideo;

end myvideo;

/
