import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

export const onVideoCreated = functions.firestore
  .document('videos/{videoId}')
  .onCreate(async (snapshot, context) => {
    //snapshot : 갓 만들어진 비디오를 참조
    snapshot.ref.update({ hello: 'from functions' });
  });
// firebase deploy --only functions : 만든 functions 디플로이 하기
/*
만약 지역에러가 난다면 functions
.region('asia-northeast3')
.firestore.document('videos/{videoId}')
이런식으로 리즌 변경해주기. 기본으로 us central 돼있음.

완료 후 빌드해서 비디오 업로드 해보면 function이 작동하여
필드에 hello: "from functions"가 추가된 것 확인가능.
*/
