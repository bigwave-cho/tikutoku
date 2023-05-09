import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp(); // admin은 god 모드, 파이어베이스의 어떤 기능이든 접근 가능

export const onVideoCreated = functions.firestore
  .document('videos/{videoId}')
  .onCreate(async (snapshot, context) => {
    const spawn = require('child-process-promise').spawn;
    const video = snapshot.data();
    await spawn('ffmpeg', [
      '-i',
      video.fileUrl,
      '-ss',
      '00:00:01.000',
      '-vframes',
      '1',
      '-vf',
      'scale=150:-1',
      `/tmp/${snapshot.id}.jpg`,
    ]);
    const storage = admin.storage();
    await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      destination: `thumbnails/${snapshot.id}.jpg`,
    });
  });

// 비디오가 업로드되면 아래 function 작동
/*
위 코드 설명
export const onVideoCreated = functions.firestore
  .document('videos/{videoId}')
  .onCreate(async (snapshot, context) => {
    const spawn = require('child-process-promise').spawn;
    const video = snapshot.data(); // 막 업로드한 비디오
    const ffmpeg = await spawn('ffmpeg', [
      '-i', // input으로
      video.fileUrl, //업로드한 비디오 url을 가져와서
      '-ss', //이동한다
      '00:00:01:000', // 0시간0분1초의 000밀리세컨드 위치로
      '-vframes', // 비디오의 프레임
      '1', // 첫 프레임을 가져와서
      '-vf', // 비디오 필터 추가
      'scale=150:-1', // 스케일 다운 : 가로 150 : 세로 -1 (-1 ffmpeg가 영상 비율에 맞춰 높이 설정)
      `/tmp/${snapshot.id}.jpg`, // 어디 저장할지 (구글 클라우드에서 코드가 실행되는 동안 임시 저장소가 활성화 됨, 거기 임시로 저장)
      // /tmp 폴더에 snapshot.id(비디오 아이디).jpg로 저장해주시오
    ]);
    const storage = admin.storage();
    // firebase storage를 불러와서
    await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      destination: `thumbnails/${snapshot.id}.jpg`,
    });
    // upload(path) : path에 있는 파일을 스토리지에 업로드
    // 업로드 위치 destination

    ffmpeg.stderr.on('data', (data: any) => {
      console.error(`stderr: ${data}`);
    });

    ffmpeg.on('close', (code: any) => {
      console.log(`child process exited with code ${code}`);
    });
  });

  chlid-process-promise를 통해 아래 명령어가 실행된다.
  `ffmpeg -i https://firebasestorage.googleapis.com/v0/b/tikutoku-jh124.appspot.com/o/videos%2FJDDkV7npGBRNunqjFRc5oKS7qO12%2F1683599429276?alt=media&token=4a9002bf-386a-4a9b-ac91-5a60bec13f76 -ss 00:00:01:000 -vframes 1 -vf scale=150:-1 /tmp/Gk9pFWRpY82yveIQCSob.jpg`
  

*/
// firebase deploy --only functions : 만든 functions 디플로이 하기
/*
만약 지역에러가 난다면 functions
.region('asia-northeast3')
.firestore.document('videos/{videoId}')
이런식으로 리즌 변경해주기. 기본으로 us central 돼있음.

완료 후 빌드해서 비디오 업로드 해보면 function이 작동하여
필드에 hello: "from functions"가 추가된 것 확인가능.

## ffmpeg
https://cloud.google.com/functions/docs/reference/system-packages#:~:text=2.31.1%2D0.4ubuntu3.7-,ffmpeg,-7%3A3.4.11%2D0ubuntu0.2

https://ffmpeg.org/ 
mp4 -> avi, 워터마크 추가, 썸네일 뽑기 등 여러 기능 가능

구글 클라우드에서 제공해주기 때문에 function으로 호출이 가능하다.

이를 위해서 로컬의 터미널에서 명령어로 ffmpeg를 다루듯이 서버에서 이를 실행해주기 위해서
아래 패키지를 설치해야 함. (functions 폴더에서 설치할 것.)

### child process promise
https://www.npmjs.com/package/child-process-promise 
*/
